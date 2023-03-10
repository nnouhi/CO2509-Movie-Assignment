// Models
import '../models/movie.dart';
import 'selected_category.dart';

class MainPageData {
  final List<Movie>? displayedMovies;
  final int? currentPage;
  final String? searchCaterogy;
  final String? queryText;

  MainPageData({
    required this.displayedMovies,
    required this.currentPage,
    required this.searchCaterogy,
    required this.queryText,
  });

  MainPageData.initial()
      : displayedMovies = [],
        currentPage = 1,
        searchCaterogy = SelectedCategory.popularCategory, // default category
        queryText = '';

  MainPageData copyWith({
    List<Movie>? displayedMovies,
    int? currentPage,
    String? searchCaterogy,
    String? searchText,
  }) {
    return MainPageData(
      displayedMovies: displayedMovies ?? this.displayedMovies,
      currentPage: currentPage ?? this.currentPage,
      searchCaterogy: searchCaterogy ?? this.searchCaterogy,
      queryText: searchText ?? this.queryText,
    );
  }
}
