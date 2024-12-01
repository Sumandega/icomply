import 'package:flutter/material.dart';

class AppTheme {
  // Primary color scheme
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.blueGrey;

  // Common text styles
  static const TextStyle titleTextStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle bodyTextStyle = TextStyle(fontSize: 16);
  static const TextStyle smallTextStyle = TextStyle(fontSize: 12, color: Colors.grey);

  // Light theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      titleLarge: titleTextStyle,
      bodyLarge: bodyTextStyle,
      bodySmall: smallTextStyle,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
  );

  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      titleLarge: titleTextStyle,
      bodyLarge: bodyTextStyle,
      bodySmall: smallTextStyle,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
  );
}
