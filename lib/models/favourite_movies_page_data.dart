// Models
import '../models/movie.dart';
import 'selected_category.dart';

class FavouriteMoviesPageData {
  final List<Movie>? displayedMovies;
  final String? sortOrder;

  FavouriteMoviesPageData({
    required this.displayedMovies,
    this.sortOrder,
  });

  FavouriteMoviesPageData.initial()
      : displayedMovies = [],
        sortOrder = DropdownCategories.none;

  FavouriteMoviesPageData copyWith({
    List<Movie>? displayedMovies,
    String? sortOrder,
  }) {
    return FavouriteMoviesPageData(
      displayedMovies: displayedMovies ?? this.displayedMovies,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
