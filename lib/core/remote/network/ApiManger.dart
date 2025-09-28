// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';

import '../../../data/model/ListMoviesResponse/ListMoviesResponse.dart';
import '../../../data/model/MovieSuggestionsResponse/MoiveSuggestionsResponse.dart';
import '../../../data/model/MoviesDetailsResponse/Movie.dart';
import '../../../data/model/MoviesDetailsResponse/MoviesDetailsResponse.dart';

class ApiManger {
  static ApiManger instance = ApiManger._init();
  static Dio dio = Dio(BaseOptions(baseUrl: "https://yts.mx/api"));

  ApiManger._init();

  static Future<List<Movie>> getListMovies({
    String sort_by = "year",
    String? genre,
    String? query_term,
  }) async {
    dynamic jsonResponse = await dio.get(
      "/v2/list_movies.json",
      queryParameters: {
        "query_term": query_term,
        "sort_by": sort_by,
        "genre": genre,
        "order_by": "desc",
      },
    );
    ListMoviesResponse response = ListMoviesResponse.fromJson(
      jsonResponse.data,
    );
    List<Movie>? moviesList = response.data?.movies ?? [];
    return moviesList;
  }

  static Future<Movie?> getMovieDetails(int movieId) async {
    dynamic responseJson = await dio.get(
      "https://yts.mx/api/v2/movie_details.json",
      queryParameters: {
        "movie_id": movieId,
        "with_cast": true,
        "with_images": true,
      },
    );
    MoviesDetailsResponse response = MoviesDetailsResponse.fromJson(
      responseJson.data,
    );

    Movie? movie = response.data?.movie;

    return movie;
  }

  static Future<List<Movie>?> getMovieSuggestions(int moviesId) async {
    dynamic resonseJson = await dio.get(
      "https://yts.mx/api/v2/movie_suggestions.json",
      queryParameters: {"movie_id": moviesId},
    );

    MoiveSuggestionsResponse response = MoiveSuggestionsResponse.fromJson(
      resonseJson.data,
    );
    List<Movie>? moives = response.data!.movies;
    return moives;
  }
}
