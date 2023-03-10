// Packages
import 'package:co2509_assignment/models/endpoints.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

// Services
import '../services/http_service.dart';

// Models
import '../models/movie.dart';

class MovieService {
  final GetIt getIt = GetIt.instance;
  late final HTTPService httpService;

  MovieService() {
    httpService = getIt.get<HTTPService>();
  }

  Future<List<Movie>> getPopularMovies(int page) async {
    try {
      Map<String, dynamic> additionalQueryParams = {'page': page};
      Response? response = await httpService.getRequest(
        Endpoints.popularMoviesEndpoint,
        additionalQueryParams,
      );
      // Success
      if (response.statusCode! == 200) {
        Map data = response.data;
        // Call Movie.fromJson to obtain a new instane of Movie
        List<Movie> movies = [];
        for (var movieData in data['results']) {
          movies.add(Movie.fromJson(movieData));
        }
        return movies;
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Movie>> getUpcomingMovies(int page) async {
    try {
      Map<String, dynamic> additionalQueryParams = {'page': page};
      Response? response = await httpService.getRequest(
        Endpoints.upcomingMoviesEndpoint,
        additionalQueryParams,
      );
      // Success
      if (response.statusCode! == 200) {
        Map data = response.data;
        // Call Movie.fromJson to obtain a new instane of Movie
        List<Movie> movies = [];
        for (var movieData in data['results']) {
          movies.add(Movie.fromJson(movieData));
        }
        return movies;
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Movie>> getSearchedMovies(String query, int page) async {
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
        for (var movieData in data['results']) {
          movies.add(Movie.fromJson(movieData));
        }
        return movies;
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
