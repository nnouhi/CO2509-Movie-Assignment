// Packages
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:tuple/tuple.dart';
// Services
import '../services/http_service.dart';
// Models
import '../models/movie.dart';
import '../models/endpoints.dart';
import '../models/more_info_movie.dart';

class MovieService {
  final GetIt getIt = GetIt.instance;
  late final HTTPService httpService;

  MovieService() {
    httpService = getIt.get<HTTPService>();
  }

  Future<bool> rateMovie(int movieId, double rating) async {
    try {
      Map<String, dynamic> body = {"value": rating};
      String endpoint = '/movie/$movieId/rating';
      Response response = await httpService.postRequest(endpoint, body);

      return true;
    } catch (e) {
      return false;
    }
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

      Map data = response.data;
      // Call Movie.fromJson to obtain a new instane of Movie
      List<Movie> movies = [];
      movies = data['results'].map<Movie>(
        (movieData) {
          return Movie.fromJson(movieData);
        },
      ).toList();

      return Tuple2(movies, data['total_pages']);
    } catch (e) {
      return const Tuple2([], 0);
    }
  }

  // Return more info about a movie
  Future<MoreInfoMovie> getMoreInfoAboutMovie(
    int movieId,
  ) async {
    try {
      Map<String, dynamic> additionalQueryParams = {};
      String endpoint = '/movie/$movieId';

      Response? response = await httpService.getRequest(
        endpoint,
        additionalQueryParams,
      );

      Map data = response.data;
      return MoreInfoMovie.fromJson(data);
    } catch (e) {
      return MoreInfoMovie.initial();
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

      Map data = response.data;
      // Call Movie.fromJson to obtain a new instane of Movie
      List<Movie> movies = [];
      movies = data['results'].map<Movie>(
        (movieData) {
          return Movie.fromJson(movieData);
        },
      ).toList();

      return Tuple2(movies, data['total_pages']);
    } catch (e) {
      return const Tuple2([], 0);
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
