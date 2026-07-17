import 'package:flutter_riverpod/flutter_riverpod.dart';

class SyncStateNotifier extends Notifier<SyncState> {
  @override
  SyncState build() => const SyncState.initial();

  void setInitial() {
    state = const SyncState.initial();
  }

  void setSyncing() {
    state = const SyncState.syncing();
  }

  void setSynced() {
    state = const SyncState.synced();
  }

  void setError(String message) {
    state = SyncState.error(message);
  }
}

abstract class SyncState {
  const SyncState();

  const factory SyncState.initial() = InitialSyncState;
  const factory SyncState.syncing() = SyncingSyncState;
  const factory SyncState.synced() = SyncedSyncState;
  const factory SyncState.error(String message) = ErrorSyncState;

  bool get isSyncing => this is SyncingSyncState || this is InitialSyncState;
  bool get hasSynced => this is SyncedSyncState;
  bool get hasError => this is ErrorSyncState;
  String? get error =>
      this is ErrorSyncState ? (this as ErrorSyncState)._message : null;
}

class InitialSyncState extends SyncState {
  const InitialSyncState();
}

class SyncingSyncState extends SyncState {
  const SyncingSyncState();
}

class SyncedSyncState extends SyncState {
  const SyncedSyncState();
}

class ErrorSyncState extends SyncState {
  const ErrorSyncState(this._message);
  final String _message;
}
