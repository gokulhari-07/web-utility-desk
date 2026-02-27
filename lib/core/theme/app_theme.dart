import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData build() {
    final TextTheme baseTextTheme =
        GoogleFonts.plusJakartaSansTextTheme(ThemeData.light().textTheme).apply(
          bodyColor: const Color(0xFF2C2A24),
          displayColor: const Color(0xFF1F2D33),
        );

    final TextTheme headingTextTheme = GoogleFonts.soraTextTheme(baseTextTheme);

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1D4250),
        brightness: Brightness.light,
      ),
      textTheme: headingTextTheme,
      scaffoldBackgroundColor: const Color(0xFFF3ECE2),
      useMaterial3: true,
    );
  }
}
