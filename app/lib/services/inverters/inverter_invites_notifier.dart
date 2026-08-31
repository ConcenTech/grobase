import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/database/inverter_invite.drift.dart';
import '../../models/invite_link.dart';
import '../database/database_providers.dart';
import '../database/online_database_service.dart';

final inverterInvitesProvider = AsyncNotifierProvider.autoDispose.family(
  (String inverterId) => InverterInvitesNotifier(inverterId),
);

/// Errors are surfaced to the UI via AsyncValue.error
///
/// Prefer ref.listen on state changes to handle errors as errors can throw
/// when invites are created or revoked as well as when building the initial
/// state.
class InverterInvitesNotifier extends AsyncNotifier<List<InverterInvite>> {
  InverterInvitesNotifier(this.inverterId);

  final String inverterId;
  late final OnlineDatabaseService _db;

  @override
  FutureOr<List<InverterInvite>> build() {
    _db = ref.read(DatabaseProviders.onlineDatabase);
    return _db.inverterInvites(inverterId);
  }

  void revoke(InverterInvite invite) async {
    assert(
      state.value != null,
      'Invites must be loaded before they can be revoked.',
    );
    final newState = state.value!
        .where((element) => element.id != invite.id)
        .toList();
    state = AsyncValue.data(newState);

    try {
      await _db.revokeInvite(invite.id);
    } on DatabaseException catch (e) {
      if (ref.mounted) {
        state = AsyncData([invite, ...state.value!]);
        state = AsyncValue.error(e, StackTrace.current);
      }
    }
  }

  Future<InviteLink?> create() async {
    try {
      final invite = await _db.createInviteLink(inverterId);
      if (state.hasValue) {
        state = AsyncData([
          InverterInvite(
            id: invite.id,
            token: invite.token,
            createdAt: DateTime.now(),
            expiresAt: invite.expiresAt,
          ),
          ...state.value!,
        ]);
      }
      return invite;
    } on DatabaseException catch (e, s) {
      if (ref.mounted) {
        state = AsyncError(e, s);
      }
      return null;
    }
  }
}
