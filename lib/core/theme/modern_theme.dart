import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernTheme {
  static const Color primaryColor = Color(0xFF000000); // Black premium
  static const Color backgroundColor = Color(0xFFF7F9FC); // Off-white clean
  static const Color surfaceColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF11142D);
  static const Color textSecondaryColor = Color(0xFF808191);
  static const Color gridLineColor = Color(0xFFEAEAEA);

  // Node colors
  static const Color nodeStart = Color(0xFF10B981); // Emerald
  static const Color nodeEnd = Color(0xFFEF4444); // Red
  static const Color nodeWall = Color(0xFF1E293B); // Slate dark
  static const Color nodeEmpty = Colors.white;
  static const Color nodeVisited = Color(0xFFBAE6FD); // Sky Light
  static const Color nodeVisiting = Color(0xFF60A5FA); // Blue
  static const Color nodePath = Color(0xFFF59E0B); // Amber

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        titleLarge: const TextStyle(color: textPrimaryColor, fontWeight: FontWeight.bold),
        titleMedium: const TextStyle(color: textPrimaryColor, fontWeight: FontWeight.w600),
        bodyLarge: const TextStyle(color: textPrimaryColor),
        bodyMedium: const TextStyle(color: textPrimaryColor),
        bodySmall: const TextStyle(color: textSecondaryColor),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        surface: surfaceColor,
      ),
      useMaterial3: true,
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: gridLineColor, width: 1),
        ),
      ),
    );
  }
}
