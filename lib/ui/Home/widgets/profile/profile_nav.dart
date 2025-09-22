// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/core/reusable_components/custom_button.dart';

import '../../../../core/resources/AssetsManager.dart';
import '../../../../core/resources/ColorManager.dart';
import 'edit_profile_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        body: SafeArea(
          child: Column(
            children: [
              const _ProfileHeader(),
              // Fixed height container for tab bar
              Container(
                height: 60, // Optimal height for tabs
                color: ColorManager.navbarColor,
                child: const _CustomTabBar(),
              ),
              Expanded(child: _TabContent()),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  void _navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          userName: "John Safwat",
          phoneNumber: "+1 234 567 8900",
        ),
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Are you sure you want to exit the application?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // You can add app exit logic here
                // SystemNavigator.pop(); // Uncomment to actually exit the app
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.navbarColor,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        children: [
          const _StatsRow(),
          const SizedBox(height: 16),
          const _UserName(),
          const SizedBox(height: 16),
          _ActionButtons(
            onEditProfile: () => _navigateToEditProfile(context),
            onExit: () => _showExitConfirmation(context),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 11),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ColorManager.yellow, width: 2),
            ),
            child: ClipOval(
              child: Image.asset(AssetsManager.red_Avatar, fit: BoxFit.cover),
            ),
          ),
        ),
        const _StatItem("Wish List", "12"),
        const _StatItem("History", "10"),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: 36,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _UserName extends StatelessWidget {
  const _UserName();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onExit;

  const _ActionButtons({required this.onEditProfile, required this.onExit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: CustomButton(
            title: const Text("Edit Profile"),
            onclick: onEditProfile,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: onExit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: ColorManager.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Exit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 5),
                Icon(Icons.logout, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomTabBar extends StatelessWidget {
  const _CustomTabBar();

  @override
  Widget build(BuildContext context) {
    return TabBar(
      dividerHeight: 0,
      indicator: const _TabIndicator(),
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: ColorManager.yellow,
      unselectedLabelColor: Colors.white70,
      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      tabs: const [
        _TabItem(
          iconSize: 18,
          asset: AssetsManager.wish_list_icon,
          label: "Watch List",
        ),
        _TabItem(iconSize: 22, asset: AssetsManager.folder, label: "History"),
      ],
    );
  }
}

class _TabIndicator extends BoxDecoration {
  const _TabIndicator()
    : super(
        border: const Border(
          bottom: BorderSide(color: ColorManager.yellow, width: 3),
        ),
      );
}

class _TabItem extends StatelessWidget {
  final double iconSize;
  final String asset;
  final String label;

  const _TabItem({
    required this.iconSize,
    required this.asset,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            asset,
            width: iconSize,
            height: iconSize,
            color: Theme.of(context).tabBarTheme.labelColor?.withOpacity(0.9),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent();

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        Center(
          child: _buildTabContent(
            "Your watch list movies will appear here",
            AssetsManager.popcorn,
          ),
        ),
        Center(
          child: _buildTabContent(
            "Your viewing history will appear here",
            AssetsManager.popcorn,
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent(String message, String imageAsset) {
    return Container(
      color: ColorManager.screen_background,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Image.asset(
              imageAsset,
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
