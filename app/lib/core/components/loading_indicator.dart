import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.centered = true, this.size = 40});

  final bool centered;
  final double size;

  @override
  Widget build(BuildContext context) {
    Widget child = SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator(),
    );

    if (centered) {
      child = Center(child: child);
    }

    return child;
  }
}
