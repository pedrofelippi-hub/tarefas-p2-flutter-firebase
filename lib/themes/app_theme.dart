import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData criar(Brightness brilho) => ThemeData(
        useMaterial3: true,
        brightness: brilho,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3459C7),
          brightness: brilho,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        appBarTheme: const AppBarTheme(centerTitle: false),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
        ),
      );
  static ThemeData get lightTheme => criar(Brightness.light);
  static ThemeData get darkTheme => criar(Brightness.dark);
}
