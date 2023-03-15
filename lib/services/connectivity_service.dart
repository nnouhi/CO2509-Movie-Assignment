// Packages
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService(this._connectivity);

  Future<bool> getConnectionState() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    print(connectivityResult.toString());
    return connectivityResult != ConnectivityResult.none;
  }
}
