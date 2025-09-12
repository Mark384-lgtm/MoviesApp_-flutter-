import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies_app/core/remote/network/ApiManger.dart';
import 'package:movies_app/core/resources/AssetsManager.dart';
import 'package:movies_app/core/resources/ColorManager.dart';
import 'package:movies_app/data/model/MoviesDetailsResponse/Movie.dart';
import 'package:movies_app/ui/Home/widgets/home_nav/widgets/MovieItem.dart';
import 'package:movies_app/ui/MoviesDetails/Widgets/CardItem.dart';
import 'package:movies_app/ui/MoviesDetails/Widgets/CastItem.dart';
import 'package:movies_app/ui/MoviesDetails/Widgets/GenreItem.dart';
import 'package:movies_app/ui/MoviesDetails/Widgets/ScreenShotItem.dart';

import '../../../data/model/MoviesDetailsResponse/Cast.dart';

class MoviesDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movie_id = ModalRoute.of(context)!.settings.arguments as int;
    print("mobie_id=${movie_id}");
    return Scaffold(
      body: FutureBuilder(
        future: ApiManger.getMovieDetails(movie_id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }
          Movie? movie = snapshot.data;
          print(
            "ptint: ${movie?.descriptionFull.toString()}" ?? "no discription",
          );
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 654,
                    child: Stack(
                      children: [
                        Image.network(
                          height: double.infinity,
                          movie!.backgroundImageOriginal!,
                          fit: BoxFit.fitHeight,
                        ),
                        Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                ColorManager.screen_background.withOpacity(0.2),
                                ColorManager.screen_background,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: double.infinity,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        size: 29,
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        size: 29,
                                        Icons.bookmark,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Image.asset(AssetsManager.play),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      textAlign: TextAlign.center,
                                      movie.title!,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      movie.year.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: ColorManager.grey,
                                            fontSize: 20,
                                          ),
                                    ),
                                    SizedBox(height: 8),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Watch",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        CardItem(
                                          AssetsManager.love,
                                          movie.likeCount ?? 0,
                                        ),
                                        CardItem(
                                          AssetsManager.duration,
                                          movie.runtime ?? 0,
                                        ),
                                        CardItem(
                                          AssetsManager.star,
                                          movie.rating?.toInt() ?? 0,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Screen Shots",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                SizedBox(height: 9),
                                ScreenShotItem(
                                  movie.mediumScreenshotImage1 ?? "",
                                ),
                                ScreenShotItem(
                                  movie.mediumScreenshotImage2 ?? "",
                                ),
                                ScreenShotItem(
                                  movie.mediumScreenshotImage3 ?? "",
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          height: 631,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Similar",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                SizedBox(height: 9),
                                FutureBuilder(
                                  future: ApiManger.getMovieSuggestions(
                                    movie_id,
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                          snapshot.error.toString(),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                      );
                                    }
                                    List<Movie> movies = snapshot.data!;
                                    return GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: movies.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 1 / 1.5,
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 20,
                                            mainAxisSpacing: 20,
                                          ),
                                      itemBuilder: (context, index) {
                                        return MovieItem(movie: movies[index]);
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          //height: 274,
                          width: double.infinity,
                          child: SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  textAlign: TextAlign.left,
                                  "Summary",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                SizedBox(height: 9),
                                Text(
                                  movie.descriptionFull.toString() != ""
                                      ? movie.descriptionFull.toString()
                                      : "no Summary available",
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.white),
                                ),
                                SizedBox(height: 9),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  textAlign: TextAlign.left,
                                  "Cast",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                SizedBox(height: 9),
                                ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 8);
                                  },
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: movie.cast!.length,
                                  itemBuilder: (context, index) {
                                    return CastItem(movie.cast![index]);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  textAlign: TextAlign.left,
                                  "Genres",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: movie.genres!.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 3,
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 11,
                                        mainAxisSpacing: 11,
                                      ),
                                  itemBuilder: (context, index) {
                                    return GenreItem(movie.genres![index]);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
