import 'package:flutter/material.dart';

import '../../../../../core/remote/network/ApiManger.dart';
import '../../../../../data/model/MoviesDetailsResponse/Movie.dart';
import 'MovieItem.dart';

class CategoryWidget extends StatelessWidget {
  final String category;

  const CategoryWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 350;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(isSmallScreen ? 4.0 : 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "see more ->",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: isSmallScreen ? 12 : 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder<List<Movie>>(
              future: ApiManger.getListMovies(genre: category),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return SizedBox(
                    height: 100,
                    child: Center(
                      child: Text(
                        'Error loading movies',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  );
                }

                List<Movie> moviesList = snapshot.data ?? [];

                if (moviesList.isEmpty) {
                  return SizedBox(
                    height: 100,
                    child: Center(
                      child: Text(
                        'No movies found',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: 200,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 4 : 8,
                    ),
                    separatorBuilder: (context, index) {
                      return SizedBox(width: isSmallScreen ? 8 : 16);
                    },
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: isSmallScreen ? 120 : 150,
                        child: MovieItem(movie: moviesList[index]),
                      );
                    },
                    itemCount: moviesList.length,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
