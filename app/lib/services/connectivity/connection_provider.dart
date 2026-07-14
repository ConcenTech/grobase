import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'connection_manager.dart';

final connectionStatusProvider = StreamProvider<bool>((ref) {
  return ref.watch(connectionProvider).stream;
});

final connectionProvider = Provider((ref) {
  final connectionManager = ConnectionManager();
  ref.onDispose(connectionManager.dispose);
  return connectionManager;
});
