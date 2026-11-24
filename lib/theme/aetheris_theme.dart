import 'package:flutter/material.dart';

class AetherisTheme {
  static const Color accent = Color(0xFF4DA3FF);
  static const Color bg = Color(0xFF0B0E14);
  static const double cornerRadius = 24;
  static const Curve fluid = Cubic(0.4, 0.0, 0.2, 1.0);

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: accent,
        scaffoldBackgroundColor: bg,
      );
}