import 'package:latlong2/latlong.dart';

/// Shared between the Map tab (features/map) and Create Complaint's location picker — both render an
/// OpenStreetMap [flutter_map] tile layer and need the same default center when location isn't
/// available yet, so it's defined once instead of duplicated per feature.
abstract final class MapConfig {
  static const String tileUrlTemplate = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String tileUserAgentPackageName = 'eg.qaaelhamour.sout_el_qaa';

  /// Qaa El Hamour's approximate center (matches the mock data's complaint coordinates) — used when
  /// the device's real location isn't available (denied permission, or picking before GPS locks).
  static const LatLng defaultCenter = LatLng(30.0444, 31.2357);

  static const double defaultZoom = 14;
}
