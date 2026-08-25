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
import '../../../complaints/domain/entities/complaint.dart';
import '../../../complaints/presentation/widgets/category_chip.dart';
import '../cubit/create_complaint_cubit.dart';
import '../cubit/create_complaint_state.dart';
import '../widgets/location_picker_page.dart';

/// Real implementation of the multi-step flow (PLAN.md section 3.6, Figma node 33:210 for step 1's
/// visual language): Fill -> Category -> Location -> Severity -> Submit -> Success.
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
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.createComplaintTitle)),
      body: BlocConsumer<CreateComplaintCubit, CreateComplaintState>(
        listener: (context, state) {
          if (state.status == CreateComplaintStatus.failure &&
              state.failureMessageKey != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      resolveMessageKey(context, state.failureMessageKey!))),
            );
          }
        },
        builder: (context, state) {
          if (state.status == CreateComplaintStatus.success) {
            return _SuccessView(complaint: state.createdComplaint!);
          }
          return _WizardBody(state: state);
        },
      ),
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
                CreateComplaintStep.fill => _FillStep(state: state),
                CreateComplaintStep.category => _CategoryStep(state: state),
                CreateComplaintStep.location => _LocationStep(state: state),
                CreateComplaintStep.severity => _SeverityStep(state: state),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: _NavButtons(state: state),
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep});

  final CreateComplaintStep currentStep;

  @override
  Widget build(BuildContext context) {
    final steps = CreateComplaintStep.values;
    final currentIndex = steps.indexOf(currentStep);

    return Row(
      children: List.generate(steps.length, (index) {
        final isReached = index <= currentIndex;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(left: index == 0 ? 0 : AppSpacing.xs),
            height: AppSpacing.xs,
            decoration: BoxDecoration(
              color: isReached
                  ? AppColors.statusStepReached
                  : AppColors.statusStepPending,
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            ),
          ),
        );
      }),
    );
  }
}

class _NavButtons extends StatelessWidget {
  const _NavButtons({required this.state});

  final CreateComplaintState state;

  @override
  Widget build(BuildContext context) {
    final isFirstStep = state.step == CreateComplaintStep.fill;
    final isLastStep = state.step == CreateComplaintStep.severity;
    final isSubmitting = state.status == CreateComplaintStatus.submitting;

    return Row(
      children: [
        if (!isFirstStep)
          Expanded(
            child: OutlinedButton(
              onPressed: isSubmitting
                  ? null
                  : () => context.read<CreateComplaintCubit>().previousStep(),
              child: Text(context.l10n.genericBack),
            ),
          ),
        if (!isFirstStep) const SizedBox(width: AppSpacing.sm),
        Expanded(
          flex: 2,
          child: AppButton(
            label: isLastStep
                ? context.l10n.submitComplaintButton
                : context.l10n.genericNext,
            isLoading: isSubmitting,
            onPressed: isLastStep
                ? () => context.read<CreateComplaintCubit>().submit()
                : () => context.read<CreateComplaintCubit>().nextStep(),
          ),
        ),
      ],
    );
  }
}

class _FillStep extends StatelessWidget {
  const _FillStep({required this.state});

  final CreateComplaintState state;

  static const _descriptionMaxLength = 300;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateComplaintCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.l10n.stepFillTitle, style: AppTypography.headingMedium),
        const SizedBox(height: AppSpacing.md),
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
        const SizedBox(height: AppSpacing.md),
        Text(context.l10n.genericOptional, style: AppTypography.metaText),
        const SizedBox(height: AppSpacing.sm),
        _MediaPicker(state: state),
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
              Positioned(
                top: -8,
                right: -8,
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

class _CategoryStep extends StatelessWidget {
  const _CategoryStep({required this.state});

  final CreateComplaintState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateComplaintCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.l10n.stepCategoryTitle,
            style: AppTypography.headingMedium),
        const SizedBox(height: AppSpacing.md),
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
      ],
    );
  }
}

class _LocationStep extends StatelessWidget {
  const _LocationStep({required this.state});

  final CreateComplaintState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateComplaintCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.l10n.stepLocationTitle,
            style: AppTypography.headingMedium),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: context.l10n.locationLabel,
          hintText: context.l10n.fieldTitleHint,
          onChanged: cubit.updateLocationLabel,
        ),
        const SizedBox(height: AppSpacing.md),
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
      ],
    );
  }
}

class _SeverityStep extends StatelessWidget {
  const _SeverityStep({required this.state});

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.l10n.stepSeverityTitle,
            style: AppTypography.headingMedium),
        const SizedBox(height: AppSpacing.md),
        Row(
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
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isSelected ? color : AppColors.surfaceOffWhite,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusPill),
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
        ),
        if (state.fieldErrors['severity'] != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            resolveMessageKey(context, state.fieldErrors['severity']!),
            style: TextStyle(color: context.colorScheme.error),
          ),
        ],
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.complaint});

  final Complaint complaint;

  @override
  Widget build(BuildContext context) {
    return Center(
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
              label: context.l10n.successBackToHomeButton,
              onPressed: () => context.go(RoutePaths.home),
            ),
          ],
        ),
      ),
    );
  }
}
