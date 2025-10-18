import 'package:flutter/material.dart';

import '../../../../../data/model/MoviesDetailsResponse/Movie.dart';
import '../../home_nav/widgets/MovieItem.dart';

class TabViewItem extends StatelessWidget {
  final List<Movie>? movies;

  const TabViewItem(this.movies, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 350;

        if (movies == null || movies!.isEmpty) {
          return const Center(
            child: Text(
              'No movies found',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return GridView.builder(
          itemCount: movies!.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.7,
            mainAxisSpacing: 8,
            crossAxisSpacing: isSmallScreen ? 8 : 16,
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            return MovieItem(movie: movies![index]);
          },
        );
      },
    );
  }
}
