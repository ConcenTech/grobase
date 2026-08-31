import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/components/card_group.dart';
import '../../core/components/loading_indicator.dart';
import '../../core/dialogs/confirmation_dialog.dart';
import '../../models/database/inverter.drift.dart';
import '../../models/database/inverter_member.drift.dart';
import '../../services/inverters/inverter_members_notifier.dart';

class InverterMembersList extends ConsumerWidget {
  const InverterMembersList({super.key, required this.inverter});

  final Inverter inverter;

  void _onRemoveMember(
    BuildContext context,
    WidgetRef ref,
    InverterMember member,
  ) async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Remove member',
      message:
          'Are you sure you wish to remove ${member.email} '
          'from this site?',
    );

    if (!confirmed || !context.mounted) {
      return;
    }

    ref.read(inverterMembersProvider(inverter.id).notifier).remove(member);
  }

  void _showErrorSnackbar(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleStyle = Theme.of(context).textTheme.bodyLarge;

    final membersProvider = inverterMembersProvider(inverter.id);

    ref.listen(membersProvider, (_, next) {
      if (next.hasError) {
        _showErrorSnackbar(context, next.error.toString());
      }
    });

    final members = ref
        .watch(membersProvider)
        .maybeWhen(
          data: (members) => members,
          loading: () => null,
          orElse: () => <InverterMember>[],
          skipLoadingOnRefresh: true,
          skipError: true,
          skipLoadingOnReload: true,
        );

    return CardGroup([
      Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 23.0, 8.0),
        child: Text('Members', style: titleStyle),
      ),
      if (members == null)
        const LoadingIndicator()
      else if (members.isEmpty)
        const SizedBox.shrink()
      else
        ListView.builder(
          itemCount: members.length,
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, index) {
            final member = members[index];
            return ListTile(
              title: Text(member.email),
              subtitle: Text(member.role.name),
              trailing: member.role == .viewer
                  ? IconButton(
                      onPressed: () => _onRemoveMember(context, ref, member),
                      icon: const Icon(MdiIcons.delete),
                    )
                  : null,
            );
          },
        ),
    ]);
  }
}
