import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/constants/map_config.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/message_key_resolver.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../complaints/domain/entities/complaint.dart';
import '../../../complaints/domain/entities/complaint_status.dart';
import '../../../complaints/domain/repositories/complaint_repository.dart';
import '../../../complaints/presentation/widgets/category_visuals.dart';
import '../../../complaints/presentation/widgets/status_badge.dart';
import '../cubit/map_cubit.dart';
import '../cubit/map_state.dart';

/// [Proposed P3] Real implementation — Figma node 33:351 is completely empty, so this screen's
/// design is ours, matching the app's visual language (same colors/typography as every other
/// screen) rather than a generic default flutter_map look.
class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MapCubit>()..load(),
      child: const _MapView(),
    );
  }
}

class _MapView extends StatelessWidget {
  const _MapView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.mapTitle)),
      body: BlocBuilder<MapCubit, MapPinsState>(
        builder: (context, state) {
          return switch (state) {
            MapPinsLoading() => const LoadingView(),
            MapPinsError(:final messageKey) => ErrorView(
                message: resolveMessageKey(context, messageKey),
                onRetry: () => context.read<MapCubit>().load(),
              ),
            MapPinsLoaded(:final pins) => FlutterMap(
                options: const MapOptions(
                  initialCenter: MapConfig.defaultCenter,
                  initialZoom: MapConfig.defaultZoom,
                ),
                children: [
                  TileLayer(
                    urlTemplate: MapConfig.tileUrlTemplate,
                    userAgentPackageName: MapConfig.tileUserAgentPackageName,
                  ),
                  MarkerLayer(
                    markers: pins
                        .map(
                          (pin) => Marker(
                            point: LatLng(pin.lat, pin.lng),
                            width: 40,
                            height: 40,
                            child: _MapPinMarker(
                              categoryId: pin.categoryId,
                              status: pin.status,
                              onTap: () => _showPinSheet(context, pin.id),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
          };
        },
      ),
    );
  }

  void _showPinSheet(BuildContext context, String complaintId) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => _MapPinSheet(complaintId: complaintId),
    );
  }
}

class _MapPinMarker extends StatelessWidget {
  const _MapPinMarker({
    required this.categoryId,
    required this.status,
    required this.onTap,
  });

  final String categoryId;
  final ComplaintStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: complaintStatusColor(status),
          border: Border.all(color: AppColors.surfaceWhite, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          categoryIcon(categoryId),
          color: AppColors.textOnBrand,
          size: 18,
        ),
      ),
    );
  }
}

/// Minimal per-pin lookup instead of pulling in the full [ComplaintDetailsCubit] just to render a
/// mini-card — the marker sheet only needs one complaint's summary, fetched directly.
class _MapPinSheet extends StatefulWidget {
  const _MapPinSheet({required this.complaintId});

  final String complaintId;

  @override
  State<_MapPinSheet> createState() => _MapPinSheetState();
}

class _MapPinSheetState extends State<_MapPinSheet> {
  Complaint? _complaint;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result =
        await getIt<ComplaintRepository>().getComplaintById(widget.complaintId);
    if (!mounted) return;
    setState(() {
      _complaint = result.fold((_) => null, (complaint) => complaint);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final complaint = _complaint;
    if (complaint == null) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ErrorView(message: context.l10n.genericErrorMessage),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(complaint.title, style: AppTypography.cardTitle),
          const SizedBox(height: AppSpacing.xs),
          Text(
            complaint.location,
            style: AppTypography.metaText,
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: context.l10n.mapViewDetailsButton,
            onPressed: () {
              Navigator.of(context).pop();
              context.push(RoutePaths.complaintDetails(complaint.id));
            },
          ),
        ],
      ),
    );
  }
}
