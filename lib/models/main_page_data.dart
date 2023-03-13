// Models
import '../models/movie.dart';
import 'selected_category.dart';

class MainPageData {
  final List<Movie>? displayedMovies;
  final int? page;
  final String? searchCaterogy;
  final String? queryText;
  final int? totalPages;
  final String? lastQueryText;
  final String? sortOrder;

  MainPageData({
    required this.displayedMovies,
    required this.page,
    required this.searchCaterogy,
    required this.queryText,
    this.totalPages,
    this.lastQueryText,
    this.sortOrder,
  });

  MainPageData.initial()
      : displayedMovies = [],
        page = 1,
        searchCaterogy = DropdownCategories.popularCategory, // default category
        queryText = '',
        totalPages = 0,
        lastQueryText = '',
        sortOrder = DropdownCategories.none;

  MainPageData copyWith({
    List<Movie>? displayedMovies,
    int? page,
    String? searchCaterogy,
    String? queryText,
    int? totalPages,
    String? lastQueryText,
    String? sortOrder,
  }) {
    return MainPageData(
      displayedMovies: displayedMovies ?? this.displayedMovies,
      page: page ?? this.page,
      searchCaterogy: searchCaterogy ?? this.searchCaterogy,
      queryText: queryText ?? this.queryText,
      totalPages: totalPages ?? this.totalPages,
      lastQueryText: lastQueryText ?? this.lastQueryText,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
