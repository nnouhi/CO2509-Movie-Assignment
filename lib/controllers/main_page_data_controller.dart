// Models
import '../models/selected_category.dart';
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
    _getAllMovies(SelectedCategory.nowPlayingCategory, 1, [], '');
  }

  final MovieService movieService = GetIt.instance.get<MovieService>();

  Future<void> _getAllMovies(
    String? searchCategory,
    int? page,
    List<Movie>? displayedMovies,
    String? queryText,
  ) async {
    try {
      List<Movie> movies = [];
      String passedQueryText = queryText!;
      String passedSearchCategory = searchCategory!;
      int passedPage = page!;

      // Search query provided
      if (passedQueryText.isNotEmpty) {
        movies = await movieService.getSearchedMovies(
          passedQueryText,
          passedPage,
        );
      }
      // No search query provided
      else {
        movies = await movieService.getSelectedMovieCategory(
          passedSearchCategory,
          passedPage,
        );
      }

      // Update state to refresh main_page.dart
      state = state.copyWith(
        searchCaterogy: passedSearchCategory,
        page: passedPage,
        displayedMovies: movies,
        queryText: passedQueryText,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  void updateQueryText(String queryText) {
    _getAllMovies(SelectedCategory.none, 1, [], queryText);
  }

  // Called from main_page.dart when user changes the movies category
  void updateMoviesGategory(int? page, String? newSearchCategory) {
    if (page! < 1) {
      // TODO HANDLE THIS
      return;
    }
    _getAllMovies(newSearchCategory, page, [], '');
  }
}
