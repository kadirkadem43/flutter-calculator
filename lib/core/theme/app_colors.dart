import 'package:flutter/material.dart';

/// Centralized Design System Colors
class AppColors {
  AppColors._();

  // Core Brand Colors (Premium Orange/Accent)
  static const Color primary = Color(0xFFFF9500); // Classic premium calculator orange
  static const Color primaryDark = Color(0xFFE58600);
  
  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF2F2F7);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1C1C1E);
  static const Color lightTextSecondary = Color(0xFF8E8E93);
  static const Color lightButtonDefault = Color(0xFFE5E5EA);
  static const Color lightButtonOperator = Color(0xFFFF9500);
  static const Color lightButtonAction = Color(0xFFD1D1D6);
  static const Color lightDivider = Color(0xFFC6C6C8);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF1C1C1E);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF8E8E93);
  static const Color darkButtonDefault = Color(0xFF333333);
  static const Color darkButtonOperator = Color(0xFFFF9500);
  static const Color darkButtonAction = Color(0xFFA5A5A5); // Lighter gray for AC, +/-, %
  static const Color darkDivider = Color(0xFF38383A);

  // State Colors
  static const Color error = Color(0xFFFF3B30);
  static const Color success = Color(0xFF34C759);
}
