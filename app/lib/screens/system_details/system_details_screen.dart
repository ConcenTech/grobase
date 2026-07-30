import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/components/app_scaffold.dart';
import '../../core/components/card_group.dart';
import '../../core/components/loading_indicator.dart';
import '../../models/database/inverter.drift.dart';
import '../../models/database/inverter_member.drift.dart';
import '../../services/database/database_providers.dart';
import 'invite_member_widget.dart';

/// A screen that displays the details of a system.
///
/// - Location, view and edit
/// - Gateway, view and replace
/// - Memebers, view, remove and invite
class SystemDetailsScreen extends StatelessWidget {
  const SystemDetailsScreen({super.key, required this.inverter});

  final Inverter inverter;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: inverter.displayName,
      showBackButton: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          const maxWidth = 500;

          final padding = EdgeInsets.symmetric(
            horizontal: screenWidth > maxWidth
                ? (screenWidth - maxWidth) / 2
                : 0,
          );

          final textTheme = Theme.of(context).textTheme;

          return SingleChildScrollView(
            padding: padding,
            child: Column(
              mainAxisSize: .min,
              children: [
                CardGroup([
                  ListTile(
                    isThreeLine: true,
                    title: const Text('Location'),
                    subtitle: RichText(
                      text: TextSpan(
                        text: 'Used for weather and sunrise/sunset.\n',
                        style: textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: inverter.location.name,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(MdiIcons.pencil),
                    ),
                  ),
                  ListTile(
                    isThreeLine: true,
                    title: const Text('Gateway'),

                    // TODO: Display the gateway serial number
                    subtitle: const Text('ABCD12345'),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(MdiIcons.swapHorizontal),
                    ),
                  ),
                ]),
                _MembersList(inverter: inverter),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MembersList extends ConsumerWidget {
  const _MembersList({super.key, required this.inverter});

  final Inverter inverter;

  void _onInviteMember(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => InviteMemberWidget(inverter: inverter),
    );
  }

  void _onRemoveMember(BuildContext context, InverterMember member) {
    _showBottomSheet(context);
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: .min,
          children: [
            Row(children: [Text('Invite Member')]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleStyle = Theme.of(context).textTheme.bodyLarge;

    final membersRef = ref.watch(
      DatabaseProviders.inverterMembers(inverter.id),
    );

    return CardGroup([
      Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 23.0, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Members', style: titleStyle),
            if (!membersRef.isLoading && !membersRef.hasError)
              IconButton(
                onPressed: () => _onInviteMember(context),
                icon: const Icon(MdiIcons.plus),
              ),
          ],
        ),
      ),
      membersRef.when(
        data: (members) {
          return ListView.builder(
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
                        onPressed: () => _onRemoveMember(context, member),
                        icon: const Icon(MdiIcons.delete),
                      )
                    : null,
              );
            },
          );
        },
        error: (e, s) {
          return const Text('Error loading members');
        },
        loading: () {
          return const LoadingIndicator();
        },
      ),
    ]);
  }
}
