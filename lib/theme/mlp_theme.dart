import 'package:flutter/material.dart';

// ── MLP Colour Palette ──────────────────────────────────────────────────────
class MlpColors {
  MlpColors._();

  // Backgrounds
  static const bg = Color(0xFF0D0D1A);        // deep dark navy
  static const surface = Color(0xFF161628);   // card surface
  static const surfaceAlt = Color(0xFF1E1E35); // slightly lighter

  // Pink accents (Pinkie Pie / Rarity vibes)
  static const pink = Color(0xFFFF85C2);       // main accent
  static const pinkLight = Color(0xFFFFB3D9);  // soft highlight
  static const pinkDark = Color(0xFFCC5599);   // pressed / deep
  static const pinkGlow = Color(0x55FF85C2);   // glow / shadow

  // Secondary purple (Twilight Sparkle)
  static const purple = Color(0xFFB57BFF);
  static const purpleGlow = Color(0x44B57BFF);

  // Status colours
  static const connected = Color(0xFF7BFFB5);    // mint green
  static const disconnected = Color(0xFFFF7B7B); // soft red
  static const connecting = Color(0xFFFFD97B);   // amber

  // Text
  static const textPrimary = Color(0xFFF5E6FF);
  static const textSecondary = Color(0xFFAA99CC);
  static const textHint = Color(0xFF665588);
}

// ── Theme ────────────────────────────────────────────────────────────────────
class MlpTheme {
  MlpTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: MlpColors.bg,
      colorScheme: const ColorScheme.dark(
        primary: MlpColors.pink,
        secondary: MlpColors.purple,
        surface: MlpColors.surface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: MlpColors.textPrimary,
        error: MlpColors.disconnected,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: MlpColors.textPrimary,
        displayColor: MlpColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: MlpColors.bg,
        foregroundColor: MlpColors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: MlpColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: MlpColors.pinkGlow, width: 1),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: MlpColors.surface,
        indicatorColor: MlpColors.pinkGlow,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(color: MlpColors.textSecondary, fontSize: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MlpColors.surfaceAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: MlpColors.pinkGlow),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: MlpColors.pinkGlow),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: MlpColors.pink, width: 2),
        ),
        hintStyle: const TextStyle(color: MlpColors.textHint),
        labelStyle: const TextStyle(color: MlpColors.textSecondary),
      ),
    );
  }
}
