// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/core/resources/AssetsManager.dart';
import 'package:movies/core/resources/ColorManager.dart';
import 'package:movies/ui/Home/widgets/profile/profile_nav.dart';

import '../widgets/browse/browse_nav.dart';
import '../widgets/home_nav/home_nav.dart';
import '../widgets/search_nav/search_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> navigationView = const [
    HomeNav(),
    SearchNav(),
    BrowseNav(),
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
              selectedFontSize: 0,
              unselectedFontSize: 0,
              items: [
                _buildBottomNavItem(
                  AssetsManager.home,
                  AssetsManager.selected_home,
                  "home",
                ),
                _buildBottomNavItem(
                  AssetsManager.search,
                  AssetsManager.selected_search,
                  "search",
                ),
                _buildBottomNavItem(
                  AssetsManager.browse,
                  AssetsManager.selected_browse,
                  "explore",
                ),
                _buildBottomNavItem(
                  AssetsManager.profile,
                  AssetsManager.selected_profile,
                  "profile",
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

  BottomNavigationBarItem _buildBottomNavItem(
    String icon,
    String activeIcon,
    String label,
  ) {
    return BottomNavigationBarItem(
      label: label,
      icon: SvgPicture.asset(icon, color: Colors.white, width: 24, height: 24),
      activeIcon: SvgPicture.asset(
        activeIcon,
        color: Colors.amber,
        width: 24,
        height: 24,
      ),
    );
  }
}
