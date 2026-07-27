import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/components/bottom_sheet_container.dart';
import '../../../services/cities_service.dart';

class NewSystemInformationWidget extends StatelessWidget {
  const NewSystemInformationWidget({super.key, required this.onStart});

  final void Function() onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomSheetContainer(
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
    );
  }
}


// // Preload cities.
//     ref.watch(citiesProvider);