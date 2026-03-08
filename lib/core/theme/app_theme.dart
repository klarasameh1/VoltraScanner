import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {

  static ThemeData lightTheme = ThemeData(

    scaffoldBackgroundColor: AppColors.background,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accentGreen,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),

    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    textTheme: const TextTheme(

      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),

      bodyMedium: TextStyle(
        fontSize: 16,
        color: AppColors.textSecondary,
      ),
    ),
  );
}