import 'package:flutter/material.dart';
import 'package:movies_app/core/resources/ColorManager.dart';
import 'package:movies_app/core/resources/RoutesManager.dart';

import '../../../../../data/model/MoviesDetailsResponse/Movie.dart';

class MovieItem extends StatelessWidget {
  Movie movie;

  MovieItem({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(RouteManager.MoviesDetailsScreen,arguments: movie.id?.toInt());
        },
        child: Stack(
          //alignment: Alignment.topLeft,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(16),
              child: Image.network(movie.mediumCoverImage!, fit: BoxFit.fitHeight),
            ),
            Container(
              padding: EdgeInsets.only(left: 8),
              margin: EdgeInsets.only(top: 5, left: 5),
              height: 28,
              decoration: BoxDecoration(
                color: ColorManager.screen_background.withOpacity(0.7),
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    movie.rating.toString(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.star, color: ColorManager.yellow),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
