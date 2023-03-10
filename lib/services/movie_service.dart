// Packages
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

// Services
import '../services/http_service.dart';

// Models
import '../models/movie.dart';

class MovieService {
  final GetIt getIt = GetIt.instance;
  late final HTTPService httpService;
  final String popularMoviesEndpoint = 'movie/popular';
  final String upcomingMoviesEndpoint = 'movie/upcoming';

  MovieService() {
    httpService = getIt.get<HTTPService>();
  }

  Future<List<Movie>> getPopularMovies(int page) async {
    try {
      Response response =
          await httpService.getRequest(popularMoviesEndpoint, page);
      // Sucess
      if (response.statusCode == 200) {
        print('200 OK');
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
