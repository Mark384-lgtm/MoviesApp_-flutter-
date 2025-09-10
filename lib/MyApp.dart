import 'package:flutter/material.dart';
import 'package:movies_app/core/resources/RoutesManager.dart';
import 'package:movies_app/core/resources/ThemeManager.dart';
import 'package:movies_app/ui/Home/Screen/HomeScreen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeMangaer.theme,
      initialRoute: RouteManager.HomeScreen,
      routes: {
        RouteManager.HomeScreen:(_)=>HomeScreen()
      },
    );
  }
}