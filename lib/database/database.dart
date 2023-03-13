// Packages
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
// Database
import 'favourite_movies_dao.dart';
// Models
import '../models/movie.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Movie])
abstract class AppDatabase extends FloorDatabase {
  FavouriteMoviesDao get moviesDao;
}
