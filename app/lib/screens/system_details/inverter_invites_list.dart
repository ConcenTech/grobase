import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/components/card_group.dart';
import '../../core/components/loading_indicator.dart';
import '../../core/dialogs/confirmation_dialog.dart';
import '../../core/env/env.dart';
import '../../models/database/inverter.drift.dart';
import '../../models/database/inverter_invite.drift.dart';
import '../../services/inverters/inverter_invites_notifier.dart';
import 'invite_member_widget.dart';

class InverterInvitesList extends ConsumerWidget {
  const InverterInvitesList({super.key, required this.inverter});

  final Inverter inverter;

  void _onRevokeInvite(
    BuildContext context,
    InverterInvite invite,
    WidgetRef ref,
  ) async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Revoke',
      message: 'Are you sure you want to revoke this invite?',
    );
    if (!confirmed) {
      return;
    }
    ref.read(inverterInvitesProvider(inverter.id).notifier).revoke(invite);
  }

  void _onCreateInvite(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => InviteMemberWidget(inverter: inverter),
    );
  }

  void _onCopyInvite(BuildContext context, String url) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Invite copied to clipboard')));
  }

  String _statusText(InverterInvite invite) {
    if (invite.acceptedAt != null) {
      return 'Accepted';
    }

    final durationToExpiry = invite.expiresAt.difference(DateTime.now());

    if (durationToExpiry.isNegative) {
      return 'Expired';
    }

    if (durationToExpiry.inDays == 0) {
      return 'Expires in ${durationToExpiry.inHours} hours';
    }

    return 'Expires in ${durationToExpiry.inDays} days';
  }

  bool _isExpired(InverterInvite invite) {
    return invite.expiresAt.isBefore(DateTime.now());
  }

  String _inviteUrl(InverterInvite invite) {
    return '${Env.projectUrl}/invite/?token=${invite.token}';
  }

  String _createdAtText(InverterInvite invite) {
    return 'Created at ${invite.createdAt.toLocal().toString()}';
  }

  void _showErrorSnackbar(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleStyle = Theme.of(context).textTheme.bodyLarge;

    final invitesProvider = inverterInvitesProvider(inverter.id);

    ref.listen(invitesProvider, (_, next) {
      if (next.hasError) {
        _showErrorSnackbar(context, next.error.toString());
      }
    });

    final invites = ref
        .watch(invitesProvider)
        .maybeWhen(
          data: (invites) => invites,
          loading: () => null,
          orElse: () => <InverterInvite>[],
          skipLoadingOnRefresh: true,
          skipError: true,
          skipLoadingOnReload: true,
        );

    return CardGroup([
      Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 23.0, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Invites', style: titleStyle),
            if (invites != null)
              IconButton(
                onPressed: () => _onCreateInvite(context, ref),
                icon: const Icon(MdiIcons.plus),
              ),
          ],
        ),
      ),
      if (invites == null)
        const LoadingIndicator()
      else if (invites.isEmpty)
        const SizedBox.shrink()
      else
        ListView.builder(
          itemCount: invites.length,
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, index) {
            final invite = invites[index];
            return ListTile(
              title: Text(_createdAtText(invite)),
              subtitle: Text(_statusText(invite)),
              trailing: !_isExpired(invite)
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () =>
                              _onCopyInvite(context, _inviteUrl(invite)),
                        ),
                        IconButton(
                          onPressed: () =>
                              _onRevokeInvite(context, invite, ref),
                          icon: const Icon(MdiIcons.delete),
                        ),
                      ],
                    )
                  : null,
            );
          },
        ),
    ]);
  }
}
