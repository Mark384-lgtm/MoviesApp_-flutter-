// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/core/resources/ColorManager.dart';
import 'package:movies/ui/Home/widgets/browse/browse_nav.dart';
import 'package:movies/ui/Home/widgets/profile/profile_nav.dart';

import '../../../core/resources/AssetsManager.dart';
import '../widgets/home_nav/home_nav.dart';
import '../widgets/search_nav/search_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> navigationView = [
    home_nav(),
    search_nav(),
    browse_nav(),
    ProfileTab(),
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 70,
            decoration: BoxDecoration(
              color: ColorManager.navbarColor,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              enableFeedback: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              currentIndex: selectedIndex,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                BottomNavigationBarItem(
                  label: "home",
                  icon: SvgPicture.asset(
                    AssetsManager.home,
                    color: Colors.white,
                  ),
                  activeIcon: SvgPicture.asset(
                    AssetsManager.selected_home,
                    color: Colors.amber,
                  ),
                ),
                BottomNavigationBarItem(
                  label: "search",
                  icon: SvgPicture.asset(
                    AssetsManager.search,
                    color: Colors.white,
                  ),
                  activeIcon: SvgPicture.asset(
                    AssetsManager.selected_search,
                    color: Colors.amber,
                  ),
                ),
                BottomNavigationBarItem(
                  label: "explore",
                  icon: SvgPicture.asset(
                    AssetsManager.browse,
                    color: Colors.white,
                  ),
                  activeIcon: SvgPicture.asset(
                    AssetsManager.selected_browse,
                    color: Colors.amber,
                  ),
                ),
                BottomNavigationBarItem(
                  label: "profile",
                  icon: SvgPicture.asset(
                    AssetsManager.profile,
                    color: Colors.white,
                  ),
                  activeIcon: SvgPicture.asset(
                    AssetsManager.selected_profile,
                    color: Colors.amber,
                  ),
                ),
              ],
              onTap: (currentIndex) {
                setState(() {
                  selectedIndex = currentIndex;
                });
              },
            ),
          ),
        ),
        body: navigationView[selectedIndex],
      ),
    );
  }
}
