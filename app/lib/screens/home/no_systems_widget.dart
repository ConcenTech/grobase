import 'package:flutter/material.dart';

class NoSystemsWidget extends StatelessWidget {
  const NoSystemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.warning, size: 48),
        SizedBox(height: 16),
        Text(
          'No systems found',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text('Please add a system to continue.', textAlign: TextAlign.center),
      ],
    );
  }
}
