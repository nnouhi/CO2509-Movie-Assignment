// Models
import '../models/movie.dart';
import '../models/search_category.dart';

class MainPageData {
  final List<Movie>? displayedMovies;
  final int? currentPage;
  final String? searchCaterogy;
  final String? searchText;

  MainPageData({
    required this.displayedMovies,
    required this.currentPage,
    required this.searchCaterogy,
    required this.searchText,
  });

  MainPageData.initial()
      : displayedMovies = [],
        currentPage = 1,
        searchCaterogy = SearchCategory.popular,
        searchText = '';

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
      searchText: searchText ?? this.searchText,
    );
  }
}
