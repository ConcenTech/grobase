import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> showLogoutDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => const _LogoutDialog(),
  );
}

class _LogoutDialog extends StatelessWidget {
  const _LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Logout'),
      contentPadding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: Text('Are you sure you want to logout?'),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Supabase.instance.client.auth.signOut();
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ],
    );
  }
}
