// Packages
import 'package:floor/floor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
// Entities
import '../entities/movie_categories.dart';

part 'offline_movies.g.dart';

@Entity(
  tableName: 'OfflineMovies',
  foreignKeys: [
    ForeignKey(
      childColumns: ['category_id'],
      parentColumns: ['categoryId'],
      entity: MovieCategories,
    )
  ],
)
@JsonSerializable(explicitToJson: false)
class OfflineMovies {
  @primaryKey
  int? id;
  int? movieId;
  String? posterPath;
  bool? adult;
  String? overview;
  String? releaseDate;
  String? originalLanguage;
  String? title;
  double voteAverage;
  @ColumnInfo(name: 'category_id')
  int? categoryId;

  OfflineMovies({
    this.id,
    this.posterPath,
    this.adult,
    this.overview,
    this.releaseDate,
    this.movieId,
    this.originalLanguage,
    this.title,
    required this.voteAverage, // Required field
    this.categoryId,
  });

  factory OfflineMovies.fromJson(Map<String, dynamic> json) =>
      _$OfflineMoviesFromJson(json);

  void setId(int id) {
    this.id = id;
  }

  void setCategoryId(int id) {
    this.categoryId = id;
  }
}


// OfflineMovies _$OfflineMoviesFromJson(Map<String, dynamic> json) =>
//     OfflineMovies(
//       posterPath: json['poster_path'] as String?,
//       adult: json['adult'] as bool?,
//       overview: json['overview'] as String?,
//       releaseDate: json['release_date'] as String?,
//       movieId: json['id'] as int?,
//       originalLanguage: json['original_language'] as String?,
//       title: json['title'] as String?,
//       voteAverage: (json['vote_average'] as num).toDouble(),
//     );