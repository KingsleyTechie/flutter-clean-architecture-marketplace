import 'package:connectivity_plus/connectivity_plus.dart';
import '../errors/failures.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Future<ConnectivityResult> get connectivityResult;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  
  NetworkInfoImpl(this.connectivity);
  
  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
  
  @override
  Future<ConnectivityResult> get connectivityResult async {
    return await connectivity.checkConnectivity();
  }
}
