import 'package:dio/dio.dart';
import 'package:movies_app/data/model/ListMoviesResponse/ListMoviesResponse.dart';
import 'package:movies_app/data/model/ListMoviesResponse/Movies.dart';

class ApiManger {
  static ApiManger instance = ApiManger._init();
  static Dio dio = Dio(BaseOptions(baseUrl: "https://yts.mx/api"));

  ApiManger._init();

  static Future<List<Movies>> getListMovies({
    String? sort_by = "year",
    String? genre = null,
  }) async {
    dynamic json_response = await dio.get(
      "/v2/list_movies.json",
      queryParameters: {"sort_by": sort_by, "genre": genre},
    );
    ListMoviesResponse response = ListMoviesResponse.fromJson(
      json_response.data,
    );
    List<Movies>? movies_list = response.data?.movies ?? [];
    return movies_list;
  }
}
