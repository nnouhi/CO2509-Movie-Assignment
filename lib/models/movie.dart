// Packages
import 'package:get_it/get_it.dart';
import 'package:floor/floor.dart';

// Models
import '../models/app_config.dart';

@entity
class Movie {
  @primaryKey
  int? id;
  String? posterPath;
  bool? adult;
  String? overview;
  String? releaseDate;
  String? originalLanguage;
  String? title;
  double voteAverage;

  Movie({
    this.posterPath,
    this.adult,
    this.overview,
    this.releaseDate,
    this.id,
    this.originalLanguage,
    this.title,
    required this.voteAverage, // Required field
  });

  // Instantiate and return a new Movie object from a JSON object
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      posterPath: json['poster_path'],
      adult: json['adult'],
      overview: json['overview'],
      releaseDate: json['release_date'],
      id: json['id'],
      originalLanguage: json['original_language'],
      title: json['title'],
      voteAverage: json['vote_average'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['poster_path'] = posterPath;
    data['adult'] = adult;
    data['overview'] = overview;
    data['release_date'] = releaseDate;
    data['id'] = id;
    data['original_language'] = originalLanguage;
    data['title'] = title;
    data['vote_average'] = voteAverage;
    return data;
  }

  String getPosterUrl() {
    final GetIt getIt = GetIt.instance;
    final AppConfig appConfig = getIt.get<AppConfig>();
    // Handle cases where posterPath is null
    if (posterPath == null) {
      return appConfig.imageNotFoundUrl;
    } else {
      return '${appConfig.baseImageUrl}${posterPath}';
    }
  }
}
