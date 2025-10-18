// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movies/core/reusable_components/custom_button.dart';

import '../../../../core/resources/AssetsManager.dart';
import '../../../../core/resources/ColorManager.dart';
import 'edit_profile_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColorManager.screen_background,
        appBar: AppBar(
          backgroundColor: ColorManager.navbarColor,
          centerTitle: true,
          title: Text(
            "Profile",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
              _ProfileHeader(user: user),
              Container(
                height: 60,
                color: ColorManager.navbarColor,
                child: const _CustomTabBar(),
              ),
              const Expanded(child: _TabContent()),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final User? user;

  const _ProfileHeader({required this.user});

  void _navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfileScreen(user: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String displayName = user?.displayName ?? 'User';
    final String? photoURL = user?.photoURL;

    return Container(
      color: ColorManager.navbarColor,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _StatsRow(photoURL: photoURL),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [_UserInfo(displayName: displayName)],
          ),
          const SizedBox(height: 10),
          _ActionButtons(
            onEditProfile: () => _navigateToEditProfile(context),
            onExit: () => _signOut(context),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final String? photoURL;

  const _StatsRow({required this.photoURL});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 350;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 11),
              child: Container(
                width: isSmallScreen ? 70 : 80,
                height: isSmallScreen ? 70 : 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorManager.yellow, width: 2),
                ),
                child: ClipOval(
                  child: photoURL != null && photoURL!.isNotEmpty
                      ? Image.network(
                          photoURL!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              AssetsManager.red_Avatar,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          AssetsManager.red_Avatar,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            const _StatItem("Wish List", "12"),
            const _StatItem("History", "10"),
          ],
        );
      },
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
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _UserInfo extends StatelessWidget {
  final String displayName;

  const _UserInfo({required this.displayName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayName,
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onExit;

  const _ActionButtons({required this.onEditProfile, required this.onExit});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 350;

        return Row(
          children: [
            Expanded(
              flex: 3,
              child: CustomButton(
                title: Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Exit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: isSmallScreen ? 16 : 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
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
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      tabs: const [
        _TabItem(
          iconSize: 16,
          asset: AssetsManager.wish_list_icon,
          label: "Watch List",
        ),
        _TabItem(iconSize: 18, asset: AssetsManager.folder, label: "History"),
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
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
        _buildTabContent(
          "Your watch list movies will appear here",
          AssetsManager.popcorn,
        ),
        _buildTabContent(
          "Your viewing history will appear here",
          AssetsManager.popcorn,
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
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
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

Future<void> _signOut(BuildContext context) async {
  final confirmed =
      await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Confirm Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ) ??
      false;

  if (confirmed) {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      // Navigate to login screen
      Navigator.pushNamedAndRemoveUntil(context, '/Login', (route) => false);
    } catch (e) {
      // Handle sign out error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
