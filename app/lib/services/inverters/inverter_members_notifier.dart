import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/database/inverter_member.drift.dart';
import '../database/database_providers.dart';
import '../database/online_database_service.dart';

final inverterMembersProvider = AsyncNotifierProvider.family(
  (String inverterId) => InverterMembersNotifier(inverterId),
);

/// Errors are surfaced to the UI via AsyncValue.error
///
/// Prefer ref.listen on state changes to handle errors as errors can throw
/// when invites are created or revoked as well as when building the initial
/// state.
class InverterMembersNotifier extends AsyncNotifier<List<InverterMember>> {
  InverterMembersNotifier(this.inverterId);

  final String inverterId;
  late final OnlineDatabaseService _db;

  @override
  FutureOr<List<InverterMember>> build() {
    _db = ref.read(DatabaseProviders.onlineDatabase);
    return _db.inverterMembers(inverterId);
  }

  void remove(InverterMember member) async {
    assert(
      state.value != null,
      'Invites must be loaded before they can be revoked.',
    );
    try {
      final newState = state.value!
          .where((element) => element.userId != member.userId)
          .toList();
      state = AsyncValue.data(newState);
      await _db.removeViewer(
        inverterId: member.inverterId,
        userId: member.userId,
      );
    } on DatabaseException catch (e) {
      if (ref.mounted) {
        // Add back to the list on failure.
        state = AsyncValue.data([member, ...state.value!]);
        state = AsyncValue.error(e, StackTrace.current);
      }
    }
  }
}
