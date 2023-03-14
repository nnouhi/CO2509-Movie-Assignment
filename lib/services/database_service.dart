import '../models/movie.dart';

class DatabaseService {
  final _db;
  late Map<int, Movie> _favouriteMovies;
  DatabaseService(this._db) {
    getFavouriteMovies().then((movies) {
      _favouriteMovies = Map.fromIterable(
        movies,
        key: (movie) => movie.id,
        value: (movie) => movie,
      );
      for (var movie in movies) {
        print(movie.title);
      }
    });

    // deleteAllFavouriteMovies();
  }

  List<Movie> getFavouriteMoviesFromMap() {
    if (_favouriteMovies.isEmpty) {
      return [];
    }
    return _favouriteMovies.values.toList();
  }

  // Wrapper methods
  Future<List<Movie>> getFavouriteMovies() async {
    return await _db.moviesDao.getFavouriteMovies();
  }

  Future<void> addFavouriteMovie(Movie movie) async {
    await _db.moviesDao.addFavouriteMovie(movie).then((value) {
      _addMovieToMap(movie);
    });
  }

  Future<void> removeMovieFromFavourites(Movie movie) async {
    await _db.moviesDao.removeFavouriteMovie(movie).then((value) {
      _favouriteMovies.remove(movie.id);
    });
  }

  Future<void> deleteAllFavouriteMovies() async {
    await _db.moviesDao.deleteAllFavouriteMovies().then((value) {
      _favouriteMovies.clear();
    });
  }

  // Helper methods
  bool existsInFavourites(int id) {
    return _favouriteMovies.containsKey(id);
  }

  void _addMovieToMap(Movie movie) {
    if (!_favouriteMovies.containsKey(movie.id)) {
      _favouriteMovies.addAll({movie.id!: movie});
    }
  }
}
