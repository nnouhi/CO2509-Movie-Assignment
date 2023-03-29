// Models
import '../models/app_config.dart';
// Packages
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class MoreInfoMovie {
  bool? adult;
  int? budget;
  List<Genres>? genres;
  int? id;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  String? posterPath;
  String? releaseDate;
  int? revenue;
  int? runtime;
  double voteAverage;

  MoreInfoMovie(
      {this.adult,
      this.budget,
      this.genres,
      this.id,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.posterPath,
      this.releaseDate,
      this.revenue,
      this.runtime,
      required this.voteAverage});

  MoreInfoMovie.initial()
      : adult = false,
        budget = 0,
        genres = <Genres>[],
        id = -1,
        originalLanguage = '',
        originalTitle = '',
        overview = '',
        posterPath = '',
        releaseDate = '',
        revenue = 0,
        runtime = 0,
        voteAverage = 0.0;

  // Wrote it manually because I didnt want to generate a .g file because it breaks the
  // Movie & Offline movie .g files
  factory MoreInfoMovie.fromJson(Map<dynamic, dynamic> json) {
    return MoreInfoMovie(
      adult: json['adult'],
      posterPath: json['backdrop_path'],
      budget: json['budget'],
      genres: json['genres'] != null
          ? (json['genres'] as List).map((i) => Genres.fromJson(i)).toList()
          : null,
      id: json['id'],
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      overview: json['overview'],
      releaseDate: json['release_date'],
      revenue: json['revenue'],
      runtime: json['runtime'],
      voteAverage: json['vote_average'].toDouble(),
    );
  }

  String getPosterUrl() {
    final GetIt getIt = GetIt.instance;
    final AppConfig appConfig = getIt.get<AppConfig>();
    // Handle cases where posterPath is null
    if (posterPath == null || posterPath!.isEmpty) {
      return appConfig.imageNotFoundUrl;
    } else {
      return '${appConfig.baseImageUrl}${posterPath}';
    }
  }

  String getRuntime() {
    if (runtime == null) {
      return '';
    }
    return "${(runtime! / 60).floor()}h:${runtime! % 60}m";
  }

  String getGenres() {
    String genresString = '';
    if (genres != null) {
      for (int i = 0; i < genres!.length; i++) {
        genresString += genres![i].name!;
        if (i != genres!.length - 1) {
          genresString += ', ';
        }
      }
    }
    return genresString;
  }

  String getInCurrencyFormat(int amount) {
    return NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    ).format(amount);
  }
}

class Genres {
  int? id;
  String? name;

  Genres({this.id, this.name});

  Genres.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
