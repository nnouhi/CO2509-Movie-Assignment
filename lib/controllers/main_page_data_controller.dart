// Models
import '../models/search_category.dart';
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

  void updateQueryText(String queryText) {
    // Update state with new search category
    state = state.copyWith(
      searchCaterogy: SearchCategory.none,
      currentPage: 1,
      displayedMovies: [],
      searchText: queryText,
    );
    _getAllMovies();
  }

  // Called from main_page.dart when user changes the movies category
  void updateMoviesGategory(String newSearchCategory) {
    // Update state with new search category
    state = state.copyWith(
        searchCaterogy: newSearchCategory,
        currentPage: 1,
        displayedMovies: [],
        searchText: '');
    _getAllMovies();
  }

  Future<void> _getAllMovies() async {
    try {
      List<Movie> movies = [];
      String stateSearchCategory = state.searchCaterogy!;
      int stateCurrentPage = state.currentPage!;
      String stateQueryText = state.queryText!;

      if (stateQueryText.isNotEmpty) {
        movies = await movieService.getSearchedMovies(
          stateQueryText,
          stateCurrentPage,
        );
      } else {
        if (stateSearchCategory == SearchCategory.popular) {
          movies = await movieService.getPopularMovies(stateCurrentPage);
        } else if (stateSearchCategory == SearchCategory.upcoming) {
          movies = await movieService.getUpcomingMovies(stateCurrentPage);
        } else {
          //TODO: Implement search
        }
      }

      // Update state
      state = state.copyWith(
          displayedMovies: [...state.displayedMovies!, ...movies],
          currentPage: state.currentPage! + 1);
    } catch (e) {}
  }
}
