// Packages
import 'package:floor/floor.dart';
// Models
import '../models/movie.dart';

@dao
abstract class FavouriteMoviesDao {
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
}
