// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:movies/ui/Home/widgets/home_nav/widgets/CategoryWidget.dart';
import 'package:movies/ui/Home/widgets/home_nav/widgets/MovieItem.dart';

import '../../../../core/remote/network/ApiManger.dart';
import '../../../../core/resources/AssetsManager.dart';
import '../../../../core/resources/ColorManager.dart';
import '../../../../core/resources/StringManger.dart';
import '../../../../data/model/MoviesDetailsResponse/Movie.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({super.key});

  @override
  State<HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  late PageController _pageController;
  late PageController _bgPageController;

  final List<String> _categories = [
    StringsManager.action,
    StringsManager.comedy,
    StringsManager.crime,
    StringsManager.history,
    StringsManager.horror,
    StringsManager.romance,
    StringsManager.drama,
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.6);
    _bgPageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bgPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>?>(
      future: ApiManger.getListMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error loading movies: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        List<Movie>? moviesList = snapshot.data;

        if (moviesList == null || moviesList.isEmpty) {
          return Center(
            child: Text(
              'No movies available',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            // Hero section with fixed height
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: _buildHeroSection(moviesList),
            ),

            // Categories section
            ..._buildCategoriesList(),
          ],
        );
      },
    );
  }

  Widget _buildHeroSection(List<Movie> moviesList) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 350;

        return Stack(
          children: [
            PageView.builder(
              itemBuilder: (context, index) {
                return Image.network(
                  moviesList[index].backgroundImageOriginal ?? '',
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      height: double.infinity,
                      width: double.infinity,
                    );
                  },
                );
              },
              physics: const NeverScrollableScrollPhysics(),
              itemCount: moviesList.length,
              controller: _bgPageController,
              scrollDirection: Axis.horizontal,
            ),
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorManager.screen_background.withOpacity(0.2),
                    ColorManager.screen_background.withOpacity(0.4),
                    ColorManager.screen_background.withOpacity(0.6),
                    ColorManager.screen_background.withOpacity(0.8),
                    ColorManager.screen_background,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 16),
                Center(
                  child: Image.asset(
                    AssetsManager.Avilable_now,
                    width: constraints.maxWidth * 0.8,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  flex: 3,
                  child: PageView.builder(
                    onPageChanged: (value) {
                      _bgPageController.animateToPage(
                        value,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: moviesList.length,
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double value = 1.0;

                          if (_pageController.position.haveDimensions) {
                            value = (_pageController.page! - index).abs();
                            value = 1 - (value * 0.3).clamp(0.0, 0.3);
                          }

                          return Center(
                            child: Transform.scale(scale: value, child: child),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 8 : 16,
                          ),
                          child: MovieItem(movie: moviesList[index]),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Image.asset(
                    AssetsManager.watch_now,
                    width: constraints.maxWidth * 0.8,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildCategoriesList() {
    return _categories.map((category) {
      return Column(
        children: [
          CategoryWidget(category: category),
          const SizedBox(height: 16),
        ],
      );
    }).toList();
  }
}
