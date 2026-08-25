import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/constants/map_config.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/permissions/permission_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/widgets/app_button.dart';

/// [Proposed P3] Full-screen "pin the location" picker for the Create Complaint wizard's Location
/// step — a center-fixed-pin map (pan the map, not drag a marker) is the simplest reliable UX with
/// flutter_map and needs no extra gesture-recognizer wiring; returns the picked [LatLng] via
/// [Navigator.pop] rather than writing into any Cubit directly (this widget doesn't know about
/// CreateComplaintCubit — the page that pushed it reads the popped result instead).
class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final _mapController = MapController();
  LatLng _center = MapConfig.defaultCenter;

  @override
  void initState() {
    super.initState();
    _initCenterFromDeviceLocation();
  }

  Future<void> _initCenterFromDeviceLocation() async {
    final permissionService = getIt<PermissionService>();
    final status = await permissionService.request(AppPermission.location);
    if (status != AppPermissionStatus.granted) return;

    try {
      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      final here = LatLng(position.latitude, position.longitude);
      setState(() => _center = here);
      _mapController.move(here, MapConfig.defaultZoom);
    } catch (_) {
      // Falls back to MapConfig.defaultCenter — a location lookup failure shouldn't block picking
      // a point manually by panning the map.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.stepLocationTitle)),
      body: Stack(
        alignment: Alignment.center,
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: MapConfig.defaultZoom,
              onPositionChanged: (camera, hasGesture) =>
                  _center = camera.center,
            ),
            children: [
              TileLayer(
                urlTemplate: MapConfig.tileUrlTemplate,
                userAgentPackageName: MapConfig.tileUserAgentPackageName,
              ),
            ],
          ),
          const Icon(Icons.location_pin,
              size: 44, color: AppColors.urgentDestructive),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: AppButton(
              label: context.l10n.genericConfirm,
              onPressed: () => Navigator.of(context).pop(_center),
            ),
          ),
        ],
      ),
    );
  }
}
