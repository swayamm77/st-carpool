import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryPurple = Color(0xFF7C4DFF);

  static const Color screenBackground = Color(0xFF121212);

  static const Color cardColor = Color(0xFF1E1E1E);

  static const Color success = Color(0xFF4CAF50);

  static const Color warning = Color(0xFFFFB300);

  static const Color error = Color(0xFFE53935);

  static const Color textSecondary = Colors.white70;

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    useMaterial3: true,

    scaffoldBackgroundColor: screenBackground,

    cardColor: cardColor,

    colorScheme: ColorScheme.dark(
      primary: primaryPurple,
      secondary: primaryPurple,
      surface: cardColor,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: screenBackground,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        side: BorderSide(color: Colors.white.withOpacity(.15)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.white.withOpacity(.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: primaryPurple, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.grey.shade900,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    dividerTheme: DividerThemeData(
      color: Colors.white.withOpacity(.08),
      thickness: 1,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryPurple,
      foregroundColor: Colors.white,
    ),
  );
}
