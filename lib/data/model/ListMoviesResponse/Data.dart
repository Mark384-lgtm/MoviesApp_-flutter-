

// ignore_for_file: file_names

import '../MoviesDetailsResponse/Movie.dart';

class Data {
  Data({
      this.movieCount, 
      this.limit, 
      this.pageNumber, 
      this.movies,});

  Data.fromJson(dynamic json) {
    movieCount = json['movie_count'];
    limit = json['limit'];
    pageNumber = json['page_number'];
    if (json['movies'] != null) {
      movies = [];
      json['movies'].forEach((v) {
        movies?.add(Movie.fromJson(v));
      });
    }
  }
  num? movieCount;
  num? limit;
  num? pageNumber;
  List<Movie>? movies;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['movie_count'] = movieCount;
    map['limit'] = limit;
    map['page_number'] = pageNumber;
    if (movies != null) {
      map['movies'] = movies?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}