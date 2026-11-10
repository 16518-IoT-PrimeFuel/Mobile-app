import 'package:flutter/material.dart';

abstract final class FullTankColors {
  static const primary = Color(0xFF1E3A8A);
  static const accent = Color(0xFFF59E0B);
  static const background = Color(0xFFF4F6F9);
  static const surface = Colors.white;
  static const text = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF4B5563);
  static const muted = Color(0xFF64748B);
  static const border = Color(0xFFDFE3E8);
  static const primarySoft = Color(0xFFE6EDFF);
  static const success = Color(0xFF14532D);
  static const successSoft = Color(0xFFDFF3E6);
  static const warning = Color(0xFF7A4100);
  static const warningSoft = Color(0xFFFFF1D6);
  static const error = Color(0xFF8A1C1C);
  static const errorSoft = Color(0xFFFDE8E8);
}

final fullTankTheme = ThemeData(
  fontFamily: 'Roboto',
  colorScheme: const ColorScheme.light(
    primary: FullTankColors.primary,
    secondary: FullTankColors.accent,
    surface: FullTankColors.surface,
    onSurface: FullTankColors.text,
    error: FullTankColors.error,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: FullTankColors.background,
  dividerColor: FullTankColors.border,
  textTheme: ThemeData.light().textTheme.apply(
    fontFamily: 'Roboto',
    bodyColor: FullTankColors.text,
    displayColor: FullTankColors.text,
  ),
);
