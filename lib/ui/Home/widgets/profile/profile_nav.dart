// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/core/reusable_components/custom_button.dart';

import '../../../../core/resources/AssetsManager.dart';
import '../../../../core/resources/ColorManager.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColorManager.screen_background,
        appBar: AppBar(
          backgroundColor: ColorManager.navbarColor,
          centerTitle: true,
          title: Text(
            "Profile",
            style: theme.textTheme.titleLarge?.copyWith(
              color: ColorManager.yellow,
              fontWeight: FontWeight.w600,
            ),
          ),
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: Column(
          children: [
            // Profile Header Section
            _buildProfileHeader(screenSize, theme),
            // Tab Bar Section
            _buildTabBar(),
            // Tab Content Section
            _buildTabContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Size screenSize, ThemeData theme) {
    return Container(
      color: ColorManager.navbarColor,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        children: [
          // Avatar and Stats Row
          _buildStatsRow(theme),
          const SizedBox(height: 16),
          // User Name
          _buildUserName(theme),
          const SizedBox(height: 16),
          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildStatsRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Avatar
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(AssetsManager.red_Avatar),
        ),
        // Wish List Stats
        _buildStatItem("Wish List", "10", theme),
        // History Stats
        _buildStatItem("History", "10", theme),
      ],
    );
  }

  Widget _buildStatItem(String title, String value, ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildUserName(ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "John Safwat",
        style: theme.textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: CustomButton(
            title: const Text("Edit Profile"),
            onclick: () {},
            // backgroundColor: ColorManager.yellow,
            // textColor: Colors.black,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: ColorManager.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Exit",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: ColorManager.navbarColor,
      height: 60,
      child: TabBar(
        isScrollable: false,
        enableFeedback: true,
        dividerHeight: 0,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: ColorManager.yellow, width: 2),
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: ColorManager.yellow,
        unselectedLabelColor: Colors.white70,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        tabs: const [
          Tab(icon: Icon(Icons.favorite_border, size: 20), text: "Wishlist"),
          Tab(icon: Icon(Icons.history, size: 20), text: "History"),
        ],
      ),
    );
  }

  // Alternative using SVG icons if preferred
  Widget _buildTabBarWithSvg() {
    return Container(
      color: ColorManager.navbarColor,
      height: 60,
      child: TabBar(
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: ColorManager.yellow, width: 2),
          ),
        ),
        dividerHeight: 0,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: ColorManager.yellow,
        unselectedLabelColor: Colors.white70,
        tabs: [
          Tab(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AssetsManager.wish_list_icon,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 4),
                const Text("Wishlist", style: TextStyle(fontSize: 11)),
              ],
            ),
          ),
          Tab(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AssetsManager.folder,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 4),
                const Text("History", style: TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return Expanded(
      child: TabBarView(
        children: [
          // Wishlist Tab
          _buildWishlistContent(),
          // History Tab
          _buildHistoryContent(),
        ],
      ),
    );
  }

  Widget _buildWishlistContent() {
    return Container(
      color: ColorManager.screen_background,
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: Text(
          "Your wishlist movies will appear here",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildHistoryContent() {
    return Container(
      color: ColorManager.screen_background,
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: Text(
          "Your viewing history will appear here",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }
}
