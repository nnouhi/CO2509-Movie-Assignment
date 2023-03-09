// Packages
import 'package:get_it/get_it.dart';

// Models
import '../models/app_config.dart';

class Movie {
  String? posterPath;
  bool? adult;
  String? overview;
  String? releaseDate;
  List<int>? genreIds;
  int? id;
  String? originalTitle;
  String? originalLanguage;
  String? title;
  String? backdropPath;
  double? popularity;
  int? voteCount;
  bool? video;
  double? voteAverage;

  Movie(
      {this.posterPath,
      this.adult,
      this.overview,
      this.releaseDate,
      this.genreIds,
      this.id,
      this.originalTitle,
      this.originalLanguage,
      this.title,
      this.backdropPath,
      this.popularity,
      this.voteCount,
      this.video,
      this.voteAverage});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      posterPath: json['poster_path'],
      adult: json['adult'],
      overview: json['overview'],
      releaseDate: json['release_date'],
      genreIds: json['genre_ids'].cast<int>(),
      id: json['id'],
      originalTitle: json['original_title'],
      originalLanguage: json['original_language'],
      title: json['title'],
      backdropPath: json['backdrop_path'],
      popularity: json['popularity'],
      voteCount: json['vote_count'],
      video: json['video'],
      voteAverage: json['vote_average'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['poster_path'] = posterPath;
    data['adult'] = adult;
    data['overview'] = overview;
    data['release_date'] = releaseDate;
    data['genre_ids'] = genreIds;
    data['id'] = id;
    data['original_title'] = originalTitle;
    data['original_language'] = originalLanguage;
    data['title'] = title;
    data['backdrop_path'] = backdropPath;
    data['popularity'] = popularity;
    data['vote_count'] = voteCount;
    data['video'] = video;
    data['vote_average'] = voteAverage;
    return data;
  }

  String getPosterUrl() {
    final GetIt getIt = GetIt.instance;
    final AppConfig appConfig = getIt.get<AppConfig>();
    return '${appConfig.baseImageUrl}${posterPath}';
  }
}
