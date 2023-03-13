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
    _getAllMovies(DropdownCategories.nowPlayingCategory, 1, [], '', '');
  }

  final MovieService movieService = GetIt.instance.get<MovieService>();

  Future<void> _getAllMovies(
    String? searchCategory,
    int? page,
    List<Movie>? displayedMovies,
    String? queryText,
    String? lastQueryText,
  ) async {
    try {
      List<Movie> movies = [];
      int totalPages = 0;
      String passedQueryText = queryText!;
      String passedSearchCategory = searchCategory!;
      int passedPage = page!;
      // Search query provided
      if (passedQueryText.isNotEmpty) {
        // Set lastQueryText to the current queryText (will be used when the user queries for a movie and wants to navigate the pages)
        await movieService
            .getSearchedMovies(
              passedQueryText,
              passedPage,
            )
            .then(
              (value) => {
                movies = value.item1,
                totalPages = value.item2,
              },
            );
      }
      // No search query provided
      else {
        await movieService
            .getSelectedMoviesCategory(
              passedSearchCategory,
              passedPage,
            )
            .then(
              (value) => {
                movies = value.item1,
                totalPages = value.item2,
              },
            );
      }

      // Update state to refresh main_page.dart
      state = state.copyWith(
        searchCaterogy: passedSearchCategory,
        page: passedPage,
        displayedMovies: movies,
        queryText: passedQueryText,
        totalPages: totalPages,
        lastQueryText: lastQueryText,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  // Called from main_page.dart when user queries for a movie
  void updateQueryText(String queryText) {
    String lastQueryText = queryText;

    _getAllMovies(
      DropdownCategories.none,
      1,
      [],
      queryText,
      lastQueryText,
    );
  }

  // Called from main_page.dart when user changes the movies category
  void updateMoviesGategory(
    int? page,
    String? newSearchCategory,
    bool? keepLastQueryText,
  ) {
    // Handle invalid page number
    if ((page! > state.totalPages!) || (page < 1)) {
      return;
    }

    // If keepLastQueryText is true, we want to keep the last query text because the user is navigating the pages of the search results
    if (keepLastQueryText!) {
      _getAllMovies(
        newSearchCategory,
        page,
        [],
        state.lastQueryText,
        state.lastQueryText,
      );
    } else {
      _getAllMovies(
        newSearchCategory,
        page,
        [],
        '',
        '',
      );
    }
  }

  // Called from main_page.dart when user sorts the movies
  void updateMoviesOrder(String? newOrder) {
    state = state.copyWith(
      searchCaterogy: state.searchCaterogy,
      page: state.page,
      displayedMovies: state.displayedMovies,
      queryText: state.queryText,
      totalPages: state.totalPages,
      lastQueryText: state.lastQueryText,
      sortOrder: newOrder,
    );
  }
}
