import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/cities_service.dart';

class NewSystemInformationWidget extends StatelessWidget {
  const NewSystemInformationWidget({super.key, required this.onStart});

  final void Function() onStart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 24,
        bottom: max(MediaQuery.of(context).viewInsets.bottom, 16),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.0,
          children: [
            // TODO: Add instructions the user needs to follow to start the new system.
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onStart, child: const Text('Start')),
            // Preload cities without rebuilding the ui.
            Consumer(
              builder: (context, ref, child) {
                ref.watch(citiesProvider);
                return child!;
              },
              child: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}


// // Preload cities.
//     ref.watch(citiesProvider);