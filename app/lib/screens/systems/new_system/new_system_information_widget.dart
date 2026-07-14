import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/cities_service.dart';

class NewSystemInformationWidget extends StatelessWidget {
  const NewSystemInformationWidget({super.key, required this.onStart});

  final void Function() onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 24,
        bottom: max(MediaQuery.of(context).viewInsets.bottom, 16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Plug in your gateway to the inverter.\n'
            'Once the light starts blinking, press start to begin.',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onStart, child: const Text('Start')),
          const SizedBox(height: 22),
          Consumer(
            builder: (context, ref, child) {
              ref.watch(citiesProvider);
              return child!;
            },
            child: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}


// // Preload cities.
//     ref.watch(citiesProvider);