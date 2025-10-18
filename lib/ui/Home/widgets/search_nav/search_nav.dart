import 'package:flutter/material.dart';
import 'package:movies/ui/Home/widgets/search_nav/widgets/SearchField.dart';

import '../../../../core/remote/network/ApiManger.dart';
import '../../../../data/model/MoviesDetailsResponse/Movie.dart';
import '../home_nav/widgets/MovieItem.dart';

class SearchNav extends StatefulWidget {
  const SearchNav({super.key});

  @override
  State<SearchNav> createState() => _SearchNavState();
}

class _SearchNavState extends State<SearchNav> {
  String? queryTerm;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>?>(
      future: ApiManger.getListMovies(query_term: queryTerm),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error searching movies: ${snapshot.error}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        List<Movie>? movies = snapshot.data;

        return LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 350;

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 16,
              ),
              child: Column(
                children: [
                  SearchField(_updateQueryTerm, queryTerm),
                  const SizedBox(height: 16),
                  Expanded(
                    child: movies == null || movies.isEmpty
                        ? Center(
                            child: Text(
                              queryTerm == null || queryTerm!.isEmpty
                                  ? 'Search for movies'
                                  : 'No movies found',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          )
                        : GridView.builder(
                            itemCount: movies.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.7,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: isSmallScreen ? 8 : 16,
                                  crossAxisCount: isSmallScreen ? 2 : 2,
                                ),
                            itemBuilder: (context, index) {
                              return MovieItem(movie: movies[index]);
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _updateQueryTerm(String? term) {
    setState(() {
      queryTerm = term;
    });
  }
}
