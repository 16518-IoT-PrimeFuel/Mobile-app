import 'package:flutter/material.dart';

const fullTankUiScale = 1.45;

Widget withFullTankUiScale(BuildContext context, Widget child) => MediaQuery(
  data: MediaQuery.of(
    context,
  ).copyWith(textScaler: const TextScaler.linear(fullTankUiScale)),
  child: child,
);

abstract final class FullTankColors {
  static const navy = Color(0xFF1A202C);
  static const navyMid = Color(0xFF2D3748);
  static const blue = Color(0xFF1E40AF);
  static const blueSoft = Color(0xFFEFF4FF);
  static const ctaFrom = Color(0xFFFFB300);
  static const ctaTo = Color(0xFFFFA500);
  static const inkMid = Color(0xFF4A5568);
  static const inkSoft = Color(0xFF94A3B8);
  static const line = Color(0xFFE2E8F0);
  static const card = Color(0xFFF3F4F6);
  static const info = Color(0xFFDBEAFE);
  static const infoBorder = Color(0xFFBFDBFE);
  static const danger = Color(0xFFEF4444);
  static const dangerSoft = Color(0xFFFEF2F2);
}

abstract final class FullTankTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: FullTankColors.blue,
            brightness: Brightness.light,
          ).copyWith(
            primary: FullTankColors.blue,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: FullTankColors.navy,
          ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: FullTankColors.navy,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.7,
        ),
        bodyMedium: TextStyle(
          color: FullTankColors.inkMid,
          fontSize: 13.5,
          height: 1.5,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: const StadiumBorder(),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: const StadiumBorder(),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
