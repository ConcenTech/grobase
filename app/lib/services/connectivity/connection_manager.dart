import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionManager {
  ConnectionManager() {
    _initialise();
  }

  bool _isOnline = true;

  Timer? _timer;

  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();

  Stream<bool> get stream => _connectionController.stream;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool get isOnline => _isOnline;

  void _initialise() {
    _subscription = Connectivity().onConnectivityChanged.listen(
      _handleConnectivityChange,
    );
  }

  void _handleConnectivityChange(List<ConnectivityResult> result) {
    // Result is never empty.
    // Result will only contain a single element of
    // ConnectivityResult.none if offline.

    // if result indicates offline and isOnline is true, go offline.
    // if result indicates online, isOnline is false and timer not running, start timer.

    if (result.contains(ConnectivityResult.none)) {
      _goOffline();
    } else if (!_isOnline && _timer == null) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 5), () {
      _goOnline();
    });
  }

  void _goOffline() {
    _timer?.cancel();
    if (_isOnline) {
      _isOnline = false;
      _connectionController.add(false);
    }
  }

  void _goOnline() {
    if (!_isOnline) {
      _isOnline = true;
      _connectionController.add(true);
    }
    _timer = null;
  }

  void dispose() {
    _timer?.cancel();
    _subscription?.cancel();
    _connectionController.close();
  }
}
