import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColors.background,

    primaryColor: AppColors.maroon,

    colorScheme: ColorScheme.dark(
      primary: AppColors.maroon,
      secondary: AppColors.yellow,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.black,
      centerTitle: true,
    ),
  );
}