import 'dart:convert';

Movie movieFromJson(String str) => Movie.fromJson(json.decode(str));

class Movie {
  Movie({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  int page;
  List<Result> results;
  int totalPages;
  int totalResults;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        page: json["page"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}

class Result {
  Result({
    required this.id,
    required this.originalTitle,
    required this.overview,
    this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
  });

  int id;
  String originalTitle;
  String overview;
  double? popularity;
  String posterPath;
  DateTime releaseDate;
  String title;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"] ?? "",
        releaseDate: json["release_date"] == ""
            ? DateTime.now()
            : DateTime.parse(json["release_date"]),
        title: json["title"],
      );
}
