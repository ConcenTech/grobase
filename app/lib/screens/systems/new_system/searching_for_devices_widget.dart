import 'package:flutter/material.dart';

import '../../../core/components/animations/bluetooth_searching_animation.dart';
import '../../../core/components/bottom_sheet_container.dart';

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
    return BottomSheetContainer(
      spacing: 16.0,
      children: [
        const BluetoothSearchingAnimation(),
        const SizedBox(height: 16),
        if (devices.isEmpty)
          Text(
            'Searching for gateways...',
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
                  title: Text(device.isEmpty ? 'Unknown Gateway' : device),
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
    );
  }
}
