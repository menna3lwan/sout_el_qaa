import 'package:connectivity_plus/connectivity_plus.dart';

/// تجريد بسيط فوق connectivity_plus — أي Repository بينادي [isConnected]
/// قبل أي remote call (القسم 5 من الـplan: Data Flow).
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
