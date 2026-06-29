import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/components/animations/bluetooth_searching_animation.dart';

class SearchingForDevicesWidget extends StatelessWidget {
  const SearchingForDevicesWidget({
    super.key,
    required this.devices,
    required this.onDeviceSelected,
  });

  final Set<String> devices;
  final void Function(String device) onDeviceSelected;

  @override
  Widget build(BuildContext context) {
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
          const BluetoothSearchingAnimation(),
          const SizedBox(height: 16),
          if (devices.isEmpty)
            Text(
              'Searching for devices...',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            )
          else
            ListView.builder(
              shrinkWrap: true,
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices.elementAt(index);
                return Card(
                  child: ListTile(
                    title: Text(device.isEmpty ? 'Unknown Device' : device),
                    subtitle: const Text('GroBase-Setup'),
                    trailing: ElevatedButton(
                      onPressed: () => onDeviceSelected(device),
                      child: const Text('Connect'),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
