import 'package:flutter/material.dart';

import '../core/components/logo.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationIcon: const LogoWidget(),
      applicationName: 'Grobase',
      applicationVersion: '0.0.1',
      applicationLegalese: '© 2026 ConcenTech Ltd. All rights reserved.',
      children: [const Text('')],
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
