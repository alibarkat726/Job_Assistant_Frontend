import 'package:flutter/material.dart';
import 'app_semantic_colors.dart';
import 'app_typography.dart';

class AppTheme {
  // Brand / Teal Accents (Shared across light and dark)
  static const brandTeal = Color(0xFF14B8A6);
  static const brandTealDark = Color(0xFF0D9488);

  // Light Tokens
  static const lightScaffoldBg = Color(0xFFEAF2FB);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightBorderDefault = Color(0xFFD6E3EF);
  static const lightBorderInput = Color(0xFFC7D8E8);
  static const lightTextPrimary = Color(0xFF1B2430);
  static const lightTextSecondary = Color(0xFF5C6B7A);
  static const lightOnAccent = Color(0xFFFFFFFF);

  // Dark Tokens
  static const darkScaffoldBg = Color(0xFF1C1F26);
  static const darkSurface = Color(0xFF20242C);
  static const darkInputSurface = Color(0xFF22262E);
  static const darkBorderDefault = Color(0xFF2E323C);
  static const darkTextPrimary = Color(0xFFFFFFFF);
  static const darkTextSecondary = Color(0xFF8E94A0);
  static const darkOnAccent = Color(0xFF0E1116);

  static ThemeData get lightTheme {
    final textTheme = AppTypography.createTextTheme(lightTextPrimary, lightTextSecondary);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightScaffoldBg,
      primaryColor: brandTeal,
      colorScheme: const ColorScheme.light(
        primary: brandTeal,
        onPrimary: lightOnAccent,
        secondary: brandTealDark,
        onSecondary: lightOnAccent,
        surface: lightSurface,
        onSurface: lightTextPrimary,
        outline: lightBorderDefault,
        error: Color(0xFFB91C1C),
        onError: Colors.white,
      ),
      textTheme: textTheme,
      extensions: const [AppSemanticColors.light],
      appBarTheme: AppBarTheme(
        backgroundColor: lightScaffoldBg,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: lightTextPrimary),
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: lightBorderDefault),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightBorderInput),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightBorderInput),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: brandTeal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB91C1C)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB91C1C), width: 2),
        ),
        labelStyle: const TextStyle(color: lightTextSecondary),
        hintStyle: TextStyle(color: lightTextSecondary.withValues(alpha: 0.7)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandTeal,
          foregroundColor: lightOnAccent,
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge?.copyWith(color: lightOnAccent),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: brandTeal,
          side: const BorderSide(color: brandTeal, width: 1.5),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge?.copyWith(color: brandTeal),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final textTheme = AppTypography.createTextTheme(darkTextPrimary, darkTextSecondary);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkScaffoldBg,
      primaryColor: brandTeal,
      colorScheme: const ColorScheme.dark(
        primary: brandTeal,
        onPrimary: darkOnAccent,
        secondary: brandTealDark,
        onSecondary: darkOnAccent,
        surface: darkSurface,
        onSurface: darkTextPrimary,
        outline: darkBorderDefault,
        error: Color(0xFFF87171),
        onError: darkOnAccent,
      ),
      textTheme: textTheme,
      extensions: const [AppSemanticColors.dark],
      appBarTheme: AppBarTheme(
        backgroundColor: darkScaffoldBg,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: darkTextPrimary),
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: darkBorderDefault),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkInputSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBorderDefault),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBorderDefault),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: brandTeal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF87171)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF87171), width: 2),
        ),
        labelStyle: const TextStyle(color: darkTextSecondary),
        hintStyle: TextStyle(color: darkTextSecondary.withValues(alpha: 0.7)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandTeal,
          foregroundColor: darkOnAccent,
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge?.copyWith(color: darkOnAccent),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: brandTeal,
          side: const BorderSide(color: brandTeal, width: 1.5),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge?.copyWith(color: brandTeal),
        ),
      ),
    );
  }
}
