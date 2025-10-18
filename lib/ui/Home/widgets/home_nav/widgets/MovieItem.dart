// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../../../../core/resources/ColorManager.dart';
import '../../../../../core/resources/RoutesManager.dart';
import '../../../../../data/model/MoviesDetailsResponse/Movie.dart';

class MovieItem extends StatelessWidget {
  final Movie movie;

  const MovieItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 150;

        return Center(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                RouteManager.MoviesDetailsScreen,
                arguments: movie.id?.toInt(),
              );
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    movie.mediumCoverImage ?? '',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        width: double.infinity,
                        height: double.infinity,
                        child: Icon(
                          Icons.movie,
                          color: Colors.grey[600],
                          size: isSmallScreen ? 30 : 40,
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: isSmallScreen ? 4 : 8),
                  margin: EdgeInsets.only(top: 5, left: 5),
                  height: isSmallScreen ? 20 : 28,
                  decoration: BoxDecoration(
                    color: ColorManager.screen_background.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        movie.rating?.toStringAsFixed(1) ?? '0.0',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 10 : 12,
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 2 : 5),
                      Icon(
                        Icons.star,
                        color: ColorManager.yellow,
                        size: isSmallScreen ? 12 : 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
