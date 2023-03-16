// Packages
import 'dart:async';
import 'package:co2509_assignment/entities/movie_categories.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
// Database
import 'dao.dart';
// Models
import '../models/movie.dart';
// Entities
import '../entities/offline_movies.dart';

part 'database.g.dart';

@Database(version: 4, entities: [Movie, MovieCategories, OfflineMovies])
abstract class AppDatabase extends FloorDatabase {
  Dao get moviesDao;
}
