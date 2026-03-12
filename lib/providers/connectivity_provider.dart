import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityProvider() {
    _initConnectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  Future<void> _initConnectivity() async {
    try {
      final List<ConnectivityResult> result = await _connectivity
          .checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      if (kDebugMode) {
        print('Connectivity check failed: $e');
      }
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // connectivity_plus 6.x returns a List<ConnectivityResult>
    // If none of the results are ConnectivityResult.none, we are connected.
    bool connected = !results.contains(ConnectivityResult.none);

    // Sometimes on iOS/Android, it returns [ConnectivityResult.none, ConnectivityResult.mobile]
    // when switching or initializing. We check if there's at least one active connection.
    if (results.isNotEmpty &&
        (results.contains(ConnectivityResult.mobile) ||
            results.contains(ConnectivityResult.wifi) ||
            results.contains(ConnectivityResult.ethernet) ||
            results.contains(ConnectivityResult.vpn))) {
      connected = true;
    } else {
      connected = false;
    }

    if (_isConnected != connected) {
      _isConnected = connected;
      notifyListeners();
    }
  }

  Future<void> checkConnection() async {
    final List<ConnectivityResult> result = await _connectivity
        .checkConnectivity();
    _updateConnectionStatus(result);
  }

  bool checkConnectionAndNotify(BuildContext context) {
    if (!_isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No Internet Connection'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
