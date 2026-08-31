import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

import '../../core/components/card_group.dart';
import '../../core/components/scaffold/app_scaffold.dart';
import '../../models/database/inverter.drift.dart';
import 'inverter_invites_list.dart';
import 'inverter_members_list.dart';

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
                    isThreeLine: false,
                    title: const Text('Gateway'),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(MdiIcons.swapHorizontal),
                    ),
                  ),
                ]),
                InverterMembersList(inverter: inverter),
                InverterInvitesList(inverter: inverter),
              ],
            ),
          );
        },
      ),
    );
  }
}
