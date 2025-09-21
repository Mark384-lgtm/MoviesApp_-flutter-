// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../../core/remote/network/ApiManger.dart';
import '../../../core/resources/AssetsManager.dart';
import '../../../core/resources/ColorManager.dart';
import '../../../data/model/MoviesDetailsResponse/Movie.dart';
import '../../Home/widgets/home_nav/widgets/MovieItem.dart';
import '../Widgets/CardItem.dart';
import '../Widgets/CastItem.dart';
import '../Widgets/GenreItem.dart';
import '../Widgets/ScreenShotItem.dart';

class MoviesDetailsScreen extends StatelessWidget {
  const MoviesDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movieId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      backgroundColor: ColorManager.screen_background,
      body: FutureBuilder<Movie?>(
        future: ApiManger.getMovieDetails(movieId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text(
                'Error loading movie details',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          final movie = snapshot.data!;
          return _buildMovieDetails(context, movie);
        },
      ),
    );
  }

  Widget _buildMovieDetails(BuildContext context, Movie movie) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 29,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmark, color: Colors.white, size: 29),
              onPressed: () {},
            ),
          ],
          expandedHeight: 400,
          flexibleSpace: FlexibleSpaceBar(background: _buildMovieHeader(movie)),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildScreenShotsSection(context, movie),
                const SizedBox(height: 24),
                _buildSimilarMoviesSection(context, movie.id!),
                const SizedBox(height: 24),
                _buildSummarySection(context, movie),
                const SizedBox(height: 24),
                _buildCastSection(context, movie),
                const SizedBox(height: 24),
                _buildGenresSection(context, movie),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieHeader(Movie movie) {
    return Stack(
      children: [
        Image.network(
          movie.backgroundImageOriginal ?? '',
          height: 400,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Container(color: Colors.grey[800], height: 400),
        ),
        Container(
          height: 400,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                ColorManager.screen_background.withOpacity(0.8),
                ColorManager.screen_background,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Image.asset(AssetsManager.play, height: 60),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  movie.title ?? 'No Title',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                movie.year?.toString() ?? '',
                style: TextStyle(color: ColorManager.grey, fontSize: 18),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      "Watch",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CardItem(AssetsManager.love, movie.likeCount ?? 0),
                    CardItem(AssetsManager.duration, movie.runtime ?? 0),
                    CardItem(AssetsManager.star, movie.rating?.toInt() ?? 0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScreenShotsSection(BuildContext context, Movie movie) {
    final screenshots = [
      movie.mediumScreenshotImage1,
      movie.mediumScreenshotImage2,
      movie.mediumScreenshotImage3,
    ].where((url) => url != null && url.isNotEmpty).toList();

    if (screenshots.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Screen Shots", style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: screenshots.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return ScreenShotItem(screenshots[index]!);
          },
        ),
      ],
    );
  }

  Widget _buildSimilarMoviesSection(BuildContext context, int movieId) {
    return FutureBuilder<List<Movie>?>(
      future: ApiManger.getMovieSuggestions(movieId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return const SizedBox();
        }

        final movies = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Similar", style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return MovieItem(movie: movies[index]);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummarySection(BuildContext context, Movie movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Summary", style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        Text(
          movie.descriptionFull?.isNotEmpty == true
              ? movie.descriptionFull!
              : movie.summary?.isNotEmpty == true
              ? movie.summary!
              : "No summary available",
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildCastSection(BuildContext context, Movie movie) {
    if (movie.cast == null || movie.cast!.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Cast", style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: movie.cast!.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return CastItem(movie.cast![index]);
          },
        ),
      ],
    );
  }

  Widget _buildGenresSection(BuildContext context, Movie movie) {
    if (movie.genres == null || movie.genres!.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Genres", style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
          ),
          itemCount: movie.genres!.length,
          itemBuilder: (context, index) {
            return GenreItem(movie.genres![index]);
          },
        ),
      ],
    );
  }
}
