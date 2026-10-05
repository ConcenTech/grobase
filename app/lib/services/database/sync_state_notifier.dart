import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier for the sync state of the database.
///
/// The sync state is a map of date times to sync states.
/// If null is the key, it means the sync state is for the entire database.
///
/// Otherwise, it means the sync state is for a specific day.
class SyncStateNotifier extends Notifier<Map<DateTime?, SyncState>> {
  @override
  Map<DateTime?, SyncState> build() => {null: const SyncState.initial()};

  void setInitial() {
    _updateState(null, const SyncState.initial());
  }

  void setSyncing(DateTime? dateTime) {
    _updateState(dateTime, const SyncState.syncing());
  }

  void setSynced(DateTime? dateTime) {
    _updateState(dateTime, const SyncState.synced());
  }

  void setError(DateTime? dateTime, String message) {
    _updateState(dateTime, SyncState.error(message));
  }

  void _updateState(DateTime? dateTime, SyncState syncState) {
    final oldState = state;
    oldState[dateTime] = syncState;
    state = {...oldState};
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
