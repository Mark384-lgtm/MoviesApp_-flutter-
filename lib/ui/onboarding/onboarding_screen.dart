// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:movies/core/resources/ColorManager.dart';
import 'package:movies/core/reusable_components/custom_button.dart';

import '../Home/Screen/HomeScreen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      "title": "Find Your Next Favorite Movie Here",
      "description":
          "Get access to a huge library of movies to suit all tastes. You will surely like it.",
      "image": "assets/images/onboarding_images/Movies Posters.png",
    },
    {
      "title": "Discover Movies",
      "description":
          "Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.",
      "image": "assets/images/onboarding_images/2nd_screen.png",
    },
    {
      "title": "Explore All Genres",
      "description":
          "Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.",
      "image": "assets/images/onboarding_images/3rd_screen.png",
    },
    {
      "title": "Create Watchlists",
      "description":
          "Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.",
      "image": "assets/images/onboarding_images/4th_screen.png",
    },
    {
      "title": "Rate, Review, and Learn",
      "description":
          "Share your thoughts on the movies you've watched. Dive deep into film details and help others discover great movies with your reviews.",
      "image": "assets/images/onboarding_images/5th_screen.png",
    },
    {
      "title": "Start Watching Now",
      "description": "",
      "image": "assets/images/onboarding_images/6th_screen.png",
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ✅ PageView for background images only
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Background image
                  Image.asset(page["image"]!, fit: BoxFit.cover),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.95),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),

      // ✅ BottomSheet for text and buttons
      bottomSheet: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorManager.screen_background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Content section
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    _pages[_currentPage]["title"]!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_pages[_currentPage]["description"]!.isNotEmpty)
                    Text(
                      _pages[_currentPage]["description"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Buttons section
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    title: Text(
                      _currentPage == 0
                          ? "Explore Now"
                          : _currentPage == _pages.length - 1
                          ? "Finish"
                          : "Next",
                      style: const TextStyle(fontSize: 16),
                    ),
                    onclick: _nextPage,
                  ),
                ),
                const SizedBox(height: 12),
                if (_currentPage > 0)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.amber, width: 2),
                        foregroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _previousPage,
                      child: const Text("Back", style: TextStyle(fontSize: 16)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
