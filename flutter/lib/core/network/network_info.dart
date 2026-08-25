import 'package:connectivity_plus/connectivity_plus.dart';

/// Thin wrapper over connectivity_plus; every Repository calls [isConnected] before a remote call (PLAN.md section 5: Data Flow).
abstract interface class NetworkInfo {
  Future<bool> get isConnected;
}

final class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }
}
