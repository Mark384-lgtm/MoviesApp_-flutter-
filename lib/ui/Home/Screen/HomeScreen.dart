import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/ui/Home/widgets/browse/browse_nav.dart';
import '../../../core/resources/AssetsManager.dart';
import '../widgets/home_nav/home_nav.dart';
import '../widgets/search_nav/search_nav.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> navigationView = [
    home_nav(),
    search_nav(),
    browse_nav(),
    Container(color: Colors.blue),
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            label: "home",
            icon: SvgPicture.asset(AssetsManager.home),
            activeIcon: SvgPicture.asset(AssetsManager.selected_home),
          ),
          BottomNavigationBarItem(
            label: "search",
            icon: SvgPicture.asset(AssetsManager.search),
            activeIcon: SvgPicture.asset(AssetsManager.selected_search),
          ),
          BottomNavigationBarItem(
            label: "explore",
            icon: SvgPicture.asset(AssetsManager.browse),
            activeIcon: SvgPicture.asset(AssetsManager.selected_browse),
          ),
          BottomNavigationBarItem(
            label: "profile",
            icon: SvgPicture.asset(AssetsManager.profile),
            activeIcon: SvgPicture.asset(AssetsManager.selected_profile),
          ),
        ],
        onTap: (currentIndex) {
          setState(() {
            selectedIndex = currentIndex;
          });
        },
      ),
      body: navigationView[selectedIndex],
    );
  }
}
