import 'package:flutter/material.dart';
import 'package:movies_app/core/resources/ColorManager.dart';

class ThemeMangaer {
  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: ColorManager.screen_background,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ColorManager.navbarColor,
      selectedItemColor: Colors.transparent,
    ),
    textTheme: TextTheme(
      bodySmall: TextStyle(color: ColorManager.yellow, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 24),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(ColorManager.red),
        padding: WidgetStatePropertyAll(
          EdgeInsets.only(top: 16, bottom: 15.25),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(15),
          ),
        ),
      ),
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: ColorManager.yellow,
    ),
  );
}
