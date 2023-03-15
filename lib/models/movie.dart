// Packages
import 'package:get_it/get_it.dart';
import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

// Models
import '../models/app_config.dart';

part 'movie.g.dart';

@JsonSerializable(explicitToJson: true)
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
  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);

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
