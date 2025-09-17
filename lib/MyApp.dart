import 'package:flutter/material.dart';
import 'package:movies/ui/Authentication/forget_pass_screen.dart';
import 'package:movies/ui/Authentication/login_screen.dart';
import 'package:movies/ui/Authentication/register_screen.dart';
import 'package:movies/ui/Home/Screen/HomeScreen.dart';
import 'package:movies/ui/MoviesDetails/Screen/MoviesDetailsScreen.dart';


import 'core/resources/RoutesManager.dart';
import 'core/resources/ThemeManager.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeMangaer.theme,
      initialRoute: RouteManager.login,
      routes: {
        RouteManager.HomeScreen:(_)=>HomeScreen(),
        RouteManager.MoviesDetailsScreen:(_)=> MoviesDetailsScreen(),
        RouteManager.forgetPassword:(_)=>ForgetPassword(),
        RouteManager.login:(_)=>LoginScreen(),
        RouteManager.register:(_)=>RegisterScreen()

      },
    );
  }
}