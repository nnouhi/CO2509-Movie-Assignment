// Controllers
import '../controllers/app_manager.dart';
// Models
import '../models/categories.dart';
import '../models/selected_category.dart';
import '../models/movie.dart';
import '../models/main_page_data.dart';
// Services
import '../services/movie_service.dart';
import '../services/database_service.dart';
// Packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
// Entities
import '../entities/offline_movies.dart';

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
      bool connection = GetIt.instance.get<AppManager>().isConnected();
      // If the user lost connection and he is not in page 1 we dont want to show him
      // the offline movies which are in page 1
      if (!connection && state.page != 1) {
        print('hello');
        return;
      } else if (!connection && state.page == 1) {
        List<Movie> movies = [];
        List<OfflineMovies> offlineMovies = await GetIt.instance
            .get<DatabaseService>()
            .getOfflineMovies(categories[searchCategory]!);
        for (var offlineMovie in offlineMovies) {
          // Create movie instance from offline movies
          movies.add(
            Movie(
              id: offlineMovie.movieId,
              title: offlineMovie.title,
              overview: offlineMovie.overview,
              posterPath: offlineMovie.posterPath,
              releaseDate: offlineMovie.releaseDate,
              voteAverage: offlineMovie.voteAverage,
              adult: offlineMovie.adult,
              originalLanguage: offlineMovie.originalLanguage,
            ),
          );
        }

        state = state.copyWith(
            searchCaterogy: searchCategory,
            page: 1,
            displayedMovies: movies,
            queryText: '',
            totalPages: 1,
            lastQueryText: lastQueryText);
        return;
      }

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

  Future<bool> rateMovie(int movieId, double rating) async {
    return await movieService.rateMovie(movieId, rating);
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

  // Reload the page
  void reloadPage() {
    state = state.copyWith();
  }

  // Called from main_page.dart when user changes the movies category
  void updateMoviesCategory(
    int? page,
    String? newSearchCategory,
    bool? keepLastQueryText,
  ) {
    // Handle invalid page number
    // temp fix
    if (state.totalPages! != 0) {
      if ((page! > state.totalPages!) || (page < 1)) {
        return;
      }
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
