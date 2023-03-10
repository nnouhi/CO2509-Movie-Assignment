// Models
import '../models/movie.dart';
import 'selected_category.dart';

class MainPageData {
  final List<Movie>? displayedMovies;
  final int? page;
  final String? searchCaterogy;
  final String? queryText;

  MainPageData({
    required this.displayedMovies,
    required this.page,
    required this.searchCaterogy,
    required this.queryText,
  });

  MainPageData.initial()
      : displayedMovies = [],
        page = 1,
        searchCaterogy = SelectedCategory.popularCategory, // default category
        queryText = '';

  MainPageData copyWith({
    List<Movie>? displayedMovies,
    int? page,
    String? searchCaterogy,
    String? queryText,
  }) {
    return MainPageData(
      displayedMovies: displayedMovies ?? this.displayedMovies,
      page: page ?? this.page,
      searchCaterogy: searchCaterogy ?? this.searchCaterogy,
      queryText: queryText ?? this.queryText,
    );
  }
}
