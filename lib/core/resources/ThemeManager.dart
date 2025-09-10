import 'package:flutter/material.dart';
import 'package:movies_app/core/resources/ColorManager.dart';

class ThemeMangaer{
  static ThemeData theme=ThemeData(
    scaffoldBackgroundColor: ColorManager.screen_background,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ColorManager.navbarColor,
      selectedItemColor: Colors.transparent
    )
  );
}