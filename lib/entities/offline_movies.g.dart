// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_movies.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfflineMovies _$OfflineMoviesFromJson(Map<String, dynamic> json) =>
    OfflineMovies(
      posterPath: json['poster_path'] as String?,
      adult: json['adult'] as bool?,
      overview: json['overview'] as String?,
      releaseDate: json['release_date'] as String?,
      movieId: json['id'] as int?,
      originalLanguage: json['original_language'] as String?,
      title: json['title'] as String?,
      voteAverage: (json['vote_average'] as num).toDouble(),
    );

Map<String, dynamic> _$OfflineMoviesToJson(OfflineMovies instance) =>
    <String, dynamic>{
      'id': instance.id,
      'movieId': instance.movieId,
      'posterPath': instance.posterPath,
      'adult': instance.adult,
      'overview': instance.overview,
      'releaseDate': instance.releaseDate,
      'originalLanguage': instance.originalLanguage,
      'title': instance.title,
      'voteAverage': instance.voteAverage,
      'categoryId': instance.categoryId,
    };
