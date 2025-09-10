import 'package:dio/dio.dart';

class ApiManger{
  static ApiManger instance=ApiManger._init();
  static Dio dio=Dio(
    BaseOptions(
      baseUrl: "https://yts.mx/api"
    )
  );
  ApiManger._init();
   static getListMovies() async {
   dynamic response= await dio.get("/v2/list_movies.json",);
  }

  getMoviesSuggestions(){

  }
}