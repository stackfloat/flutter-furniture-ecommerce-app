import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._(); // Prevent instantiation

  // Brand seed color
  static const Color _seedColor = Colors.black;

  // ---------- LIGHT THEME ----------
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    // Material 3 Color Scheme (SOURCE OF TRUTH)
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    ),

    // Scaffold
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),

    // AppBar
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      centerTitle: false,
    ),

    // Typography
    textTheme: const TextTheme(
      bodySmall: TextStyle(fontSize: 11),
      bodyMedium: TextStyle(fontSize: 12),
      bodyLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),

      displaySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      displayLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),

      headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black, // ← Black background
        foregroundColor: Colors.white, // ← White text
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        disabledBackgroundColor: const Color.fromARGB(255, 25, 22, 22).withValues(alpha: 0.4),
        disabledForegroundColor: Colors.white.withValues(alpha: 0.8),          
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Colors.black),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        side: const BorderSide(color: Colors.black),
            
      ),
    ),

    // Input fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF2F6F9),
      errorStyle: TextStyle(color: Colors.red, fontSize: 14),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12, // ← Adjust this for height
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFC3C3C3), width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFC3C3C3), width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      thickness: 1,
      color: Color(0xFFE0E0E0),
    ),
  );

  // ---------- DARK THEME ----------
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ).copyWith(onPrimary: Colors.black, onSecondary: Colors.black),

    scaffoldBackgroundColor: Colors.black,

    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
  );
}
