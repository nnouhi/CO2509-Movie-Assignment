// Models
import '../models/movie.dart';
import '../models/main_page_data.dart';

// Services
import '../services/movie_service.dart';

// Packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

class MainPageDataController extends StateNotifier<MainPageData> {
  MainPageDataController([MainPageData? state])
      : super(state ?? MainPageData.initial()) {
    _getAllMovies();
  }

  final MovieService movieService = GetIt.instance.get<MovieService>();

  Future<void> _getAllMovies() async {
    try {
      List<Movie> movies = [];
      movies = await movieService.getPopularMovies(state.currentPage!);

      state = state.copyWith(
          displayedMovies: [...state.displayedMovies!, ...movies],
          currentPage: state.currentPage! + 1);
    } catch (e) {}
  }
}
