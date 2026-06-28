import 'package:flutter/material.dart';

class RenewableEnergySiteImage extends StatelessWidget {
  const RenewableEnergySiteImage({super.key, this.size = 400});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/renewable-energy-site.png',
      fit: BoxFit.contain,
      width: size,
    );
  }
}
