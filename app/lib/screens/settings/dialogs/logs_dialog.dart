import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/app_logger.dart';

Future<void> showLogsDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => const _LogsDialog(),
  );
}

class _LogsDialog extends StatelessWidget {
  const _LogsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final logStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.merge(GoogleFonts.robotoMono());

    return SimpleDialog(
      title: const Text('Logs'),
      contentPadding: const EdgeInsets.all(16),
      children: [
        SizedBox(
          width: size.width * 0.85,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SelectableText(
              AppLogger.instance.formatted(),
              style: logStyle,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
