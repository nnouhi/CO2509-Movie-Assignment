// Packages
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:tuple/tuple.dart';
// Services
import '../services/http_service.dart';
// Models
import '../models/movie.dart';
import '../models/endpoints.dart';

class MovieService {
  final GetIt getIt = GetIt.instance;
  late final HTTPService httpService;

  MovieService() {
    httpService = getIt.get<HTTPService>();
  }

  // Returns the total pages and a list of movies based on the selected category
  Future<Tuple2<List<Movie>, int>> getSelectedMoviesCategory(
    String selectedCategory,
    int page,
  ) async {
    try {
      Map<String, dynamic> additionalQueryParams = {'page': page};
      String endpoint = _getEndpoint(selectedCategory);
      Response? response = await httpService.getRequest(
        endpoint,
        additionalQueryParams,
      );
      // Success
      if (response.statusCode! == 200) {
        Map data = response.data;
        // Call Movie.fromJson to obtain a new instane of Movie
        List<Movie> movies = [];
        movies = data['results'].map<Movie>((movieData) {
          return Movie.fromJson(movieData);
        }).toList();
        return Tuple2(movies, data['total_pages']);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      print(e);
      return Tuple2([], 0);
    }
  }

  // Search for movies
  Future<Tuple2<List<Movie>, int>> getSearchedMovies(
    String query,
    int page,
  ) async {
    try {
      Map<String, dynamic> additionalQueryParams = {
        'query': query,
        'page': page,
      };

      Response response = await httpService.getRequest(
        Endpoints.searchMoviedEndpoint,
        additionalQueryParams,
      );
      // Success
      if (response.statusCode == 200) {
        Map data = response.data;
        // Call Movie.fromJson to obtain a new instane of Movie
        List<Movie> movies = [];
        movies = data['results'].map<Movie>((movieData) {
          return Movie.fromJson(movieData);
        }).toList();
        return Tuple2(movies, data['total_pages']);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      print(e);
      return Tuple2([], 0);
    }
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
