// Controllers
import '../controllers/app_manager.dart';
// Services
import '../services/http_service.dart';
import '../services/sharedpreferences_service.dart';
// Entities
import '../entities/movie_categories.dart';
import '../entities/offline_movies.dart';
// Packages
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
// Models
import '../models/endpoints.dart';
import '../models/movie.dart';
import '../models/categories.dart';

class DatabaseService {
  final _db;
  late Map<int, Movie> _favouriteMovies;
  DatabaseService(this._db) {
    SharedPreferencesService sps =
        GetIt.instance.get<SharedPreferencesService>();

    _checkIfFirstTimeUser(sps);
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

  Future<void> addMovieCategory(MovieCategories category) async {
    await _db.moviesDao.addCategory(category).then((value) {
      print(category);
    });
  }

  Future<List<MovieCategories>> getMovieCategories() {
    return _db.moviesDao.getCategories();
  }

  Future<void> addOfflineMovies(List<OfflineMovies> movies) async {
    await _db.moviesDao.addOfflineMovies(movies).then((value) {});
  }

  Future<void> deleteAllOfflineMovies() async {
    await _db.moviesDao.deleteAllOfflineMovies().then((value) {
      print('All offline movies deleted');
    });
  }

  Future<List<OfflineMovies>> getAllOfflineMovies() {
    return _db.moviesDao.getAllOfflineMovies();
  }

  Future<List<OfflineMovies>> getOfflineMovies(int categoryId) {
    return _db.moviesDao.getOfflineMovies(categoryId);
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

  void _checkIfFirstTimeUser(SharedPreferencesService sps) async {
    bool isFirstTimeUser = await sps.getBool('isFirstTimeUser');
    // isFirstTimeUser = true;
    if (isFirstTimeUser) {
      await sps.setBool('isFirstTimeUser', false);

      // Get movie category map and itterate
      // Use for loop with await
      for (var entry in categories.entries) {
        MovieCategories category = MovieCategories(
          categoryId: entry.value,
          categoryName: entry.key,
        );
        await addMovieCategory(category);
      }
    } else {
      // Get all the favourite movies and add them to the map
      getFavouriteMovies().then(
        (movies) {
          _favouriteMovies = Map.fromIterable(
            movies,
            key: (movie) => movie.id,
            value: (movie) => movie,
          );
          for (var movie in movies) {
            print(movie.title);
          }
        },
      );
    }

    bool isConnected = GetIt.instance.get<AppManager>().isConnected();
    if (isConnected) {
      // Get all the offline movies and add them to the map
      List<OfflineMovies> offlineMovies = await getAllOfflineMovies();
      if (offlineMovies.isNotEmpty) {
        print('All movies deleted');
        // Delete all offline movies from database and fetch new possibly updated ones from the API
        deleteAllOfflineMovies();
      }

      // Fetch all the movies from the API and add them to the database
      Response response;
      Map data;
      String endpoint;
      HTTPService http = GetIt.instance.get<HTTPService>();
      Map<String, dynamic> additionalQueryParams = {'page': 1};
      List<OfflineMovies> movies = [];
      int offlineMovieId = 0;
      for (var entry in categories.entries) {
        endpoint = _getEndpoint(entry.key);
        response = await http.getRequest(endpoint, additionalQueryParams);
        data = response.data;
        movies = data['results'].map<OfflineMovies>(
          (movieData) {
            offlineMovieId++;
            OfflineMovies movie = OfflineMovies.fromJson(movieData);
            movie.setId(offlineMovieId);
            movie.setCategoryId(entry.value);
            return movie;
          },
        ).toList();

        // for (var movie in movies) {
        //   // print id and title
        //   print('${movie.categoryId} - ${movie.title}');
        // }

        // print('---------------------------------');

        // Add the movies to the database
        addOfflineMovies(movies);
      }

      // List<OfflineMovies> tempMovies = await getOfflineMovies(3);
      // for (var movie in tempMovies) {
      //   print(movie.title);
      // }
    }
    // List<OfflineMovies> tempMovies = await getOfflineMovies(1);
    // for (var movie in tempMovies) {
    //   print(movie.title);
    // }
  }

  // Helper method to get the endpoint based on the selected category
  String _getEndpoint(String selectedCategory) {
    switch (selectedCategory) {
      case 'Now Playing':
        return Endpoints.nowPlayingMoviesEndpoint;
      case 'Popular':
        return Endpoints.popularMoviesEndpoint;
      case 'Top Rated':
        return Endpoints.topRatedPMoviesEndpoint;
      case 'Upcoming':
        return Endpoints.upcomingMoviesEndpoint;
      default:
        return '';
    }
  }
}
