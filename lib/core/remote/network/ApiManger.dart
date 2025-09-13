import 'package:dio/dio.dart';
import 'package:movies_app/data/model/ListMoviesResponse/ListMoviesResponse.dart';
import 'package:movies_app/data/model/MoviesDetailsResponse/MoviesDetailsResponse.dart';
import 'package:movies_app/data/model/MovieSuggestionsResponse/MoiveSuggestionsResponse.dart';
import '../../../data/model/MoviesDetailsResponse/Movie.dart';

class ApiManger {
  static ApiManger instance = ApiManger._init();
  static Dio dio = Dio(BaseOptions(baseUrl: "https://yts.mx/api"));

  ApiManger._init();

  static Future<List<Movie>> getListMovies({
    String sort_by = "year",
    String? genre,
    String? query_term
  }) async {
    dynamic json_response = await dio.get(
      "/v2/list_movies.json",
      queryParameters: {
        "query_term": query_term,
        "sort_by": sort_by,
        "genre": genre,
        "order_by": "desc"
      },
    );
    ListMoviesResponse response = ListMoviesResponse.fromJson(
      json_response.data,
    );
    List<Movie>? movies_list = response.data?.movies ?? [];
    return movies_list;
  }

  static Future<Movie?> getMovieDetails(int movie_id) async {
    dynamic response_json = await dio.get(
      "https://yts.mx/api/v2/movie_details.json",
      queryParameters: {
        "movie_id": movie_id,
        "with_cast": true,
        "with_images": true,
      },
    );
    MoviesDetailsResponse response = MoviesDetailsResponse.fromJson(
      response_json.data,
    );

    Movie? movie = response.data?.movie;

    return movie;
  }

  static Future<List<Movie>?> getMovieSuggestions(int movies_id) async {
    dynamic resonse_json = await dio.get(
      "https://yts.mx/api/v2/movie_suggestions.json",
      queryParameters: {"movie_id": movies_id},
    );

    MoiveSuggestionsResponse response = MoiveSuggestionsResponse.fromJson(
      resonse_json.data,
    );
    List<Movie>? moives = response.data!.movies;
    return moives;
  }
}
