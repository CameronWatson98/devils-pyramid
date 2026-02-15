import 'package:devils_pyramid/styles/colours.dart';
import 'package:flutter/material.dart';

ThemeData get darkTheme => ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: ThemeColors.primary,
    onPrimary: ThemeColors.onPrimary,
    secondary: ThemeColors.secondary,
    onSecondary: ThemeColors.onSecondary,
    error: ThemeColors.error,
    onError: ThemeColors.onPrimary,
    surface: ThemeColors.surface,
    onSurface: ThemeColors.onSurface,
    surfaceDim: ThemeColors.surface.withValues(alpha: 0.05),
  ),
  fontFamily: 'Lexend',
  brightness: Brightness.dark,
  scaffoldBackgroundColor: ThemeColors.background,
);
