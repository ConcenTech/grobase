import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/invite_preview.dart';
import '../../services/database/database_providers.dart';
import '../../services/database/online_database_service.dart';

final inviteScreenProvider = NotifierProvider.autoDispose
    .family<InviteScreenStateNotifier, InviteScreenState, String>(
      InviteScreenStateNotifier.new,
    );

abstract class InviteScreenState {
  const InviteScreenState();

  bool get isLoading => this is InviteScreenStateLoadingPreview;
  bool get hasError => this is InviteScreenStateError;
  bool get hasPreview => this is InviteScreenStatePreviewLoaded;
}

class InviteScreenStateLoadingPreview extends InviteScreenState {
  const InviteScreenStateLoadingPreview();
}

class InviteScreenStatePreviewLoaded extends InviteScreenState {
  final InvitePreview preview;

  /// If the user has accepted the invite, and we are waiting for
  /// the server to confirm it.
  final bool isAccepting;
  const InviteScreenStatePreviewLoaded(this.preview, this.isAccepting);

  InviteScreenStatePreviewLoaded toAccepting() {
    return InviteScreenStatePreviewLoaded(preview, true);
  }

  InviteScreenStateAccepted toAccepted() {
    return InviteScreenStateAccepted(preview);
  }
}

class InviteScreenStateError extends InviteScreenState {
  final String message;
  const InviteScreenStateError(this.message);
}

class InviteScreenStateAccepted extends InviteScreenStatePreviewLoaded {
  const InviteScreenStateAccepted(InvitePreview preview)
    : super(preview, false);
}

class InviteScreenStateNotifier extends Notifier<InviteScreenState> {
  InviteScreenStateNotifier(this.token);

  late final OnlineDatabaseService _db;

  final String token;

  @override
  InviteScreenState build() {
    _db = ref.read(DatabaseProviders.onlineDatabase);
    _loadPreview();
    return const InviteScreenStateLoadingPreview();
  }

  void _loadPreview() async {
    try {
      final preview = await _db.getInvitePreview(token);
      state = InviteScreenStatePreviewLoaded(preview, false);
    } on DatabaseException catch (e) {
      state = InviteScreenStateError(e.message);
    }
  }

  void acceptInvite() async {
    assert(state is InviteScreenStatePreviewLoaded);

    final currentState = (state as InviteScreenStatePreviewLoaded);
    state = currentState.toAccepting();

    try {
      await _db.acceptInvite(token);
      state = currentState.toAccepted();
    } on DatabaseException catch (e) {
      state = InviteScreenStateError(e.message);
    }
  }
}
