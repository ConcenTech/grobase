import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseFont = GoogleFonts.montserrat(
      fontWeight: FontWeight.w600,
      fontSize: 48,
      color: const Color(0xFF6EB92B),
    );
    final accentFont = GoogleFonts.montserrat(
      fontWeight: FontWeight.w600,
      fontSize: 48,
      color: isDark ? Colors.white : const Color(0xFF37474F),
    );
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      child: RichText(
        text: TextSpan(
          text: 'Gro',
          style: baseFont,
          children: [TextSpan(text: 'base', style: accentFont)],
        ),
      ),
    );
  }
}
