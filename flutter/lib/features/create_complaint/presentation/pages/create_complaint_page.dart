import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/message_key_resolver.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../complaints/domain/entities/category.dart';
import '../../../complaints/domain/entities/complaint.dart';
import '../../../complaints/presentation/widgets/category_chip.dart';
import '../../../complaints/presentation/widgets/category_visuals.dart';
import '../cubit/create_complaint_cubit.dart';
import '../cubit/create_complaint_state.dart';
import '../widgets/location_picker_page.dart';

/// [Updated, Full Audit & Sync pass, 27 Aug 2026] Now a 2-pre-submission-step flow —
/// Form -> Review -> Submit -> Success — matching the redesigned Figma (nodes 33:210 for the combined
/// form, 59:1207 for the new review step, 59:1389 for success); was Fill -> Category -> Location ->
/// Severity -> Submit -> Success (4 field-group steps). See [CreateComplaintStep]'s doc comment for
/// why the field-level state model barely changed even though the screens did.
class CreateComplaintPage extends StatelessWidget {
  const CreateComplaintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CreateComplaintCubit>()..loadCategories(),
      child: const _CreateComplaintView(),
    );
  }
}

class _CreateComplaintView extends StatelessWidget {
  const _CreateComplaintView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateComplaintCubit, CreateComplaintState>(
      listener: (context, state) {
        if (state.status == CreateComplaintStatus.failure &&
            state.failureMessageKey != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(resolveMessageKey(context, state.failureMessageKey!))),
          );
        }
      },
      builder: (context, state) {
        final isSuccess = state.status == CreateComplaintStatus.success;
        // Figma shows a shorter AppBar title ("تقديم شكوي") on the review/success screens than on the
        // form screen ("تقديم شكوي جديدة") — and no back button at all on the form screen (it's the
        // wizard's entry point), a real leading back arrow on review (returns to the form, same
        // action as "تعديل الشكوى") and success (returns Home).
        final isFormStep = !isSuccess && state.step == CreateComplaintStep.form;

        return Scaffold(
          appBar: AppBar(
            title: Text(isFormStep
                ? context.l10n.createComplaintTitle
                : context.l10n.createComplaintTitleShort),
            automaticallyImplyLeading: false,
            leading: isFormStep
                ? null
                : IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      if (isSuccess) {
                        context.go(RoutePaths.home);
                      } else {
                        context.read<CreateComplaintCubit>().previousStep();
                      }
                    },
                  ),
          ),
          body: isSuccess
              ? _SuccessView(complaint: state.createdComplaint!)
              : _WizardBody(state: state),
        );
      },
    );
  }
}

class _WizardBody extends StatelessWidget {
  const _WizardBody({required this.state});

  final CreateComplaintState state;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: _StepIndicator(currentStep: state.step),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: switch (state.step) {
                CreateComplaintStep.form => _FormStep(state: state),
                CreateComplaintStep.review => _ReviewStep(state: state),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: switch (state.step) {
              CreateComplaintStep.form => const _FormNavButton(),
              CreateComplaintStep.review => _ReviewActions(state: state),
            },
          ),
        ],
      ),
    );
  }
}

/// 3 numbered circular badges + connecting line — replaces the old 4-equal-pill-segment bar (Figma
/// nodes 33:210/59:1207/59:1389's step indicator is unrelated to [ComplaintStatusStepper] on the
/// Complaint Details page, which already had this circular shape; the two are kept as separate
/// widgets since one lives in create_complaint/ and reflects wizard progress, the other in
/// complaints/ and reflects backend complaint status — different domains, coincidentally similar look).
class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep});

  final CreateComplaintStep currentStep;

  /// The wizard is really 3 numbered steps (Form / Review / Success) but only 2 are
  /// [CreateComplaintStep] values — Success is reached via [CreateComplaintStatus.success], not a 3rd
  /// step here, so this indicator (only rendered during [_WizardBody], i.e. pre-submission) never
  /// needs to represent it; [_SuccessView] renders its own 3rd-badge-active copy of this bar.
  int get _activeIndex =>
      currentStep == CreateComplaintStep.form ? 0 : 1;

  @override
  Widget build(BuildContext context) => _StepIndicatorRow(activeIndex: _activeIndex);
}

class _StepIndicatorRow extends StatelessWidget {
  const _StepIndicatorRow({required this.activeIndex});

  /// Index (0-based) of the currently-active step among the 3 numbered badges.
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        if (i.isOdd) {
          // Connecting line between badges.
          return Expanded(
            child: Container(height: 1, color: AppColors.borderNeutral),
          );
        }
        final stepIndex = i ~/ 2;
        return _StepBadge(stepNumber: stepIndex + 1, isActive: stepIndex == activeIndex, isCompleted: stepIndex < activeIndex);
      }),
    );
  }
}

class _StepBadge extends StatelessWidget {
  const _StepBadge({
    required this.stepNumber,
    required this.isActive,
    required this.isCompleted,
  });

  final int stepNumber;
  final bool isActive;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final Color background;
    final Color border;
    if (isCompleted) {
      background = AppColors.warningFigma;
      border = AppColors.brandPrimary;
    } else if (isActive) {
      background = AppColors.headerBackground;
      border = AppColors.avatarBorder;
    } else {
      background = AppColors.surfaceOffWhite;
      border = AppColors.borderNeutral;
    }

    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: background,
        border: Border.all(color: border, width: 2),
      ),
      child: Text(
        '$stepNumber',
        style: AppTypography.numericCounter.copyWith(
          color: isCompleted || isActive
              ? AppColors.textOnBrand
              : AppColors.textMutedGrey,
        ),
      ),
    );
  }
}

/// Form step's single action — Figma's step-1 button is styled and labeled identically to the real
/// submit button ("إرسال الشكوة") even though it only advances to Review here; kept as the same
/// literal copy Figma shows rather than inventing a "Next" label it doesn't have (documented in the
/// audit report as a should-confirm ambiguity). Takes no [CreateComplaintState] — validation runs
/// entirely inside [CreateComplaintCubit.nextStep], so there is nothing here for the widget to read.
class _FormNavButton extends StatelessWidget {
  const _FormNavButton();

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: context.l10n.submitComplaintButton,
      onPressed: () => context.read<CreateComplaintCubit>().nextStep(),
    );
  }
}

/// Review step's actions — Figma node 59:1207: "إلغاء الشكوى" (Cancel) + "تعديل الشكوى" (Edit) side
/// by side above the full-width submit button, not the old Back/Next row.
class _ReviewActions extends StatelessWidget {
  const _ReviewActions({required this.state});

  final CreateComplaintState state;

  @override
  Widget build(BuildContext context) {
    final isSubmitting = state.status == CreateComplaintStatus.submitting;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: isSubmitting ? null : () => _confirmCancel(context),
              icon: const Icon(Icons.delete_outline,
                  size: 18, color: AppColors.urgentDestructive),
              label: Text(
                context.l10n.createComplaintCancelButton,
                style: AppTypography.chipLabel
                    .copyWith(color: AppColors.textFigmaPrimary, fontSize: 14),
              ),
            ),
            TextButton.icon(
              onPressed: isSubmitting
                  ? null
                  : () => context.read<CreateComplaintCubit>().previousStep(),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: Text(
                context.l10n.createComplaintEditButton,
                style: AppTypography.chipLabel.copyWith(fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: context.l10n.submitComplaintButton,
          isLoading: isSubmitting,
          onPressed: () => context.read<CreateComplaintCubit>().submit(),
        ),
      ],
    );
  }

  /// [New] Figma shows "إلغاء الشكوى" (Cancel Complaint) with a delete icon, but doesn't specify a
  /// confirmation dialog — reusing the same confirm-before-destructive-action pattern already
  /// established for Profile's logout (see profile_page.dart's `_confirmLogout`) rather than either
  /// silently discarding the draft or inventing a different confirmation UI.
  Future<void> _confirmCancel(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.createComplaintCancelButton),
        content: Text(context.l10n.genericConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.genericBack),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              context.l10n.genericConfirm,
              style: const TextStyle(color: AppColors.urgentDestructive),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.pop();
    }
  }
}

/// [Updated] The combined form — Figma node 33:210 groups every field on one screen instead of the
/// old 4 separate step screens (Fill/Category/Location/Severity). Field order follows Figma's layout
/// (Media -> Category -> Description -> Location -> Severity); the title field is kept even though
/// Figma's form doesn't show one — [Complaint.title] is a required domain/backend field and removing
/// it would drop required data, not just change a screen, so it's placed right above Description
/// rather than invented a new position for it. See the audit report's Remaining Issues for this
/// specific ambiguity (documented, not silently resolved either way).
class _FormStep extends StatelessWidget {
  const _FormStep({required this.state});

  final CreateComplaintState state;

  static const _descriptionMaxLength = 300;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateComplaintCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.md),
        Text(context.l10n.genericOptional, style: AppTypography.metaText),
        const SizedBox(height: AppSpacing.sm),
        _MediaPicker(state: state),
        const SizedBox(height: AppSpacing.lg),
        Text(context.l10n.stepCategoryTitle, style: AppTypography.headingMedium),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: state.categories
              .map(
                (category) => CategoryChip(
                  category: category,
                  isSelected: category.id == state.categoryId,
                  onTap: () => cubit.selectCategory(category.id),
                ),
              )
              .toList(),
        ),
        if (state.fieldErrors['category'] != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            resolveMessageKey(context, state.fieldErrors['category']!),
            style: TextStyle(color: context.colorScheme.error),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: context.l10n.fieldTitleLabel,
          hintText: context.l10n.fieldTitleHint,
          onChanged: cubit.updateTitle,
          errorText: state.fieldErrors['title'] == null
              ? null
              : resolveMessageKey(context, state.fieldErrors['title']!),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: context.l10n.fieldDescriptionLabel,
          hintText: context.l10n.fieldDescriptionHint,
          maxLines: 5,
          maxLength: _descriptionMaxLength,
          onChanged: cubit.updateDescription,
          errorText: state.fieldErrors['description'] == null
              ? null
              : resolveMessageKey(context, state.fieldErrors['description']!),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(context.l10n.stepLocationTitle, style: AppTypography.headingMedium),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          label: context.l10n.locationLabel,
          hintText: context.l10n.fieldTitleHint,
          onChanged: cubit.updateLocationLabel,
        ),
        const SizedBox(height: AppSpacing.md),
        // Static illustrated map preview (Figma node 33:210's "Image" placeholder, section 3.6) —
        // decorative context for the button below, not tied to the actually-picked location.
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Image.asset(
            'assets/images/map/bikini_bottom_map.png',
            width: double.infinity,
            height: 90,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: () async {
            final picked = await Navigator.of(context).push<LatLng>(
              MaterialPageRoute<LatLng>(
                  builder: (_) => const LocationPickerPage()),
            );
            if (picked != null) {
              cubit.selectLocation(
                lat: picked.latitude,
                lng: picked.longitude,
                location: state.location,
              );
            }
          },
          icon: const Icon(Icons.map_outlined),
          label: Text(context.l10n.pickLocationOnMapButton),
        ),
        if (state.hasLocation) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${context.l10n.locationSelectedLabel}: '
            '${state.lat!.toStringAsFixed(4)}, ${state.lng!.toStringAsFixed(4)}',
            style: AppTypography.metaText,
          ),
        ],
        if (state.fieldErrors['location'] != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            resolveMessageKey(context, state.fieldErrors['location']!),
            style: TextStyle(color: context.colorScheme.error),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        Text(context.l10n.stepSeverityTitle, style: AppTypography.headingMedium),
        const SizedBox(height: AppSpacing.sm),
        _SeverityPicker(state: state),
        if (state.fieldErrors['severity'] != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            resolveMessageKey(context, state.fieldErrors['severity']!),
            style: TextStyle(color: context.colorScheme.error),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class _MediaPicker extends StatelessWidget {
  const _MediaPicker({required this.state});

  final CreateComplaintState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateComplaintCubit>();

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        ...state.mediaUrls.map(
          (url) => Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                child: Image.network(url,
                    width: 72, height: 72, fit: BoxFit.cover),
              ),
              PositionedDirectional(
                top: -8,
                end: -8,
                child: IconButton(
                  icon: const Icon(Icons.cancel, size: 20),
                  onPressed: () => cubit.removePhoto(url),
                  tooltip: context.l10n.removePhotoLabel,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: state.isUploadingMedia
              ? null
              : () async {
                  final picked = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (picked != null) await cubit.attachPhoto(picked.path);
                },
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surfaceLightGrey,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: AppColors.borderNeutral),
            ),
            child: state.isUploadingMedia
                ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.add_a_photo_outlined),
          ),
        ),
      ],
    );
  }
}

class _SeverityPicker extends StatelessWidget {
  const _SeverityPicker({required this.state});

  final CreateComplaintState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateComplaintCubit>();
    final options = [
      (
        ComplaintSeverity.high,
        context.l10n.severityHighLabel,
        AppColors.severityHighSelected
      ),
      (
        ComplaintSeverity.medium,
        context.l10n.severityMediumLabel,
        AppColors.statusInProgressChip
      ),
      (
        ComplaintSeverity.low,
        context.l10n.severityLowLabel,
        AppColors.statusStepReached
      ),
    ];

    return Row(
      children: options.map((option) {
        final (severity, label, color) = option;
        final isSelected = state.severity == severity;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: InkWell(
              onTap: () => cubit.selectSeverity(severity),
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  color: isSelected ? color : AppColors.surfaceOffWhite,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  border: Border.all(
                    color: isSelected ? color : AppColors.borderNeutral,
                    width: 2,
                  ),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTypography.chipLabel.copyWith(
                    color: isSelected
                        ? AppColors.textOnBrand
                        : AppColors.textSecondaryGrey,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// [New, Full Audit & Sync pass, 27 Aug 2026] Review step — Figma node 59:1207: a read-only summary
/// card (photo + category badge, title, description, location/severity meta rows) with Edit/Cancel
/// actions below it (see [_ReviewActions]) and the real submit button. Did not exist before this pass.
class _ReviewStep extends StatelessWidget {
  const _ReviewStep({required this.state});

  final CreateComplaintState state;

  @override
  Widget build(BuildContext context) {
    final category = state.selectedCategory;
    final hasPhoto = state.mediaUrls.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.md),
        Text(
          context.l10n.createComplaintReviewTitle,
          textAlign: TextAlign.center,
          style: AppTypography.pageHeading,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          context.l10n.createComplaintReviewSubtitle,
          textAlign: TextAlign.center,
          style: AppTypography.metaText,
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.borderFigmaStrong),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (hasPhoto) ...[
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(state.mediaUrls.first,
                            fit: BoxFit.cover),
                      ),
                    ),
                    if (category != null)
                      PositionedDirectional(
                        top: AppSpacing.sm,
                        end: AppSpacing.sm,
                        child: _ReviewCategoryBadge(category: category),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
              ] else if (category != null) ...[
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: _ReviewCategoryBadge(category: category),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              Text(
                state.title.isEmpty ? context.l10n.fieldTitleLabel : state.title,
                style: AppTypography.cardTitle
                    .copyWith(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(state.description, style: AppTypography.bodyDefault),
              const SizedBox(height: AppSpacing.sm),
              _ReviewMetaRow(
                icon: Icons.location_on_outlined,
                label: context.l10n.locationLabel,
                value: state.location.isEmpty
                    ? context.l10n.genericOptional
                    : state.location,
              ),
              const SizedBox(height: AppSpacing.xs),
              _ReviewMetaRow(
                icon: Icons.warning_amber_outlined,
                label: context.l10n.stepSeverityTitle,
                value: switch (state.severity) {
                  ComplaintSeverity.high => context.l10n.severityHighLabel,
                  ComplaintSeverity.medium => context.l10n.severityMediumLabel,
                  ComplaintSeverity.low => context.l10n.severityLowLabel,
                  null => '—',
                },
                valueColor: AppColors.urgentDestructive,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class _ReviewCategoryBadge extends StatelessWidget {
  const _ReviewCategoryBadge({required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        boxShadow: const [
          BoxShadow(color: Color(0x1A002652), blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(category.name,
              style: AppTypography.statusChipLabel
                  .copyWith(color: AppColors.textFigmaPrimary, fontSize: 12)),
          const SizedBox(width: AppSpacing.xs),
          Icon(categoryIcon(category.id),
              size: 14, color: AppColors.textFigmaPrimary),
        ],
      ),
    );
  }
}

class _ReviewMetaRow extends StatelessWidget {
  const _ReviewMetaRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceOffWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textFigmaSecondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppTypography.metaText
                        .copyWith(color: AppColors.textFigmaSecondary)),
                Text(
                  value,
                  style: AppTypography.metaText.copyWith(
                    color: valueColor ?? AppColors.textFigmaPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// [Updated] Success screen — Figma node 59:1389: exact copy re-confirmed against the redesigned
/// Figma ("شكوتك وصلت للقاع! 🎉" / "تم إرسال شكوتك بنجاح، وشفيق استلمها 😂"), a new
/// "مشاهدة الشكوى" (View Complaint) button added above the existing "back to home" one, and the
/// step indicator now shown here too (3rd badge active) instead of disappearing entirely.
class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.complaint});

  final Complaint complaint;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: _StepIndicatorRow(activeIndex: 2),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle,
                        size: 72, color: AppColors.statusResolvedChip),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      context.l10n.successTitle,
                      style: AppTypography.pageHeading,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      context.l10n.successMessage,
                      style: context.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppButton(
                      label: context.l10n.successViewComplaintButton,
                      onPressed: () => context
                          .push(RoutePaths.complaintDetails(complaint.id)),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    OutlinedButton(
                      onPressed: () => context.go(RoutePaths.home),
                      child: Text(context.l10n.successBackToHomeButton),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
