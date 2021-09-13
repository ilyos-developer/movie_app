import 'package:catalog_films/models/movie.dart';
import 'package:dio/dio.dart';

class ApiClient {
  static const baseUrl = 'https://api.themoviedb.org/3';
  static const apiKey = "6ccd72a2a8fc239b13f209408fc31c33";

  static BaseOptions options =
      BaseOptions(baseUrl: baseUrl, connectTimeout: 15000);
  final Dio dio = Dio(options);

  final String lang = "ru";

  Future getMovies({int page = 1}) async {
    try {
      final response = await dio.get("/discover/movie",
          queryParameters: {"api_key": apiKey, "language": lang, "page": page});
      print(response.data);
      final movies = Movie.fromJson(response.data);
      return movies;
    } catch (e) {
      print(e);
    }
  }

  Future searchMovie(String name) async {
    final response = await dio.get("/search/movie",
        queryParameters: {"api_key": apiKey, "language": lang, "query": name});
    print(response.data);
    final movies = Movie.fromJson(response.data);
    return movies;
  }
}
