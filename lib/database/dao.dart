// Packages
import 'package:co2509_assignment/entities/offline_movies.dart';
import 'package:floor/floor.dart';
// Models
import '../entities/movie_categories.dart';
import '../models/movie.dart';

@dao
abstract class Dao {
  // Favourite Movies
  @insert
  Future<void> addFavouriteMovie(Movie movie);
  @delete
  Future<void> removeFavouriteMovie(Movie movie);
  @Query('DELETE FROM Movie')
  Future<void> deleteAllFavouriteMovies();
  @Query('SELECT * FROM Movie')
  Future<List<Movie>> getFavouriteMovies();
  @Query('SELECT * FROM Movie WHERE id = :id')
  Stream<Movie?> findFavouriteById(int id);

  // Categories
  @insert
  Future<void> addCategory(MovieCategories movieCategories);
  @Query('SELECT * FROM MovieCategories')
  Future<List<MovieCategories>> getCategories();

  // Offline Movies
  @insert
  Future<void> addOfflineMovies(List<OfflineMovies> movies);
  @Query('DELETE FROM OfflineMovies')
  Future<void> deleteAllOfflineMovies();
  @Query(
      'SELECT * FROM OfflineMovies OM INNER JOIN MovieCategories MC ON OM.category_id = MC.categoryId WHERE MC.categoryId = :categoryId ')
  Future<List<OfflineMovies>> getOfflineMovies(int categoryId);
  @Query('SELECT * FROM OfflineMovies')
  Future<List<OfflineMovies>> getAllOfflineMovies();
}
