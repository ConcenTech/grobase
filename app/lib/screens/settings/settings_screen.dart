import 'package:flutter/material.dart';

import '../../core/components/card_group.dart';
import 'dialogs/logout_dialog.dart';
import 'dialogs/logs_dialog.dart';
import 'theme_preference_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;

        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: Column(
              children: [
                const CardGroup([
                  ThemePreferenceWidget(), //
                ]),
                CardGroup([
                  ListTile(
                    title: const Text('Logs'),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () => showLogsDialog(context),
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    trailing: const Icon(Icons.logout),
                    onTap: () => showLogoutDialog(context),
                  ),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }
}
