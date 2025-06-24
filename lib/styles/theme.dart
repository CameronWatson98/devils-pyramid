import 'package:devils_pyramid/styles/colours.dart';
import 'package:flutter/material.dart';

ThemeData get darkTheme => ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: ThemeColors.primary,
    onPrimary: ThemeColors.text,
    secondary: ThemeColors.secondary,
    onSecondary: ThemeColors.text,
    error: ThemeColors.error,
    onError: ThemeColors.text,
    surface: ThemeColors.surface,
    onSurface: ThemeColors.text,
    surfaceDim: ThemeColors.text.withValues(alpha: 0.05),
  ),

  brightness: Brightness.dark,
  scaffoldBackgroundColor: ThemeColors.background,
);
