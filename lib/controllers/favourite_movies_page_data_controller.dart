// Packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
// Models
import '../models/favourite_movies_page_data.dart';
import '../models/movie.dart';
// Services
import '../services/database_service.dart';

class FavouriteMoviesPageDataController
    extends StateNotifier<FavouriteMoviesPageData> {
  late GetIt getit;
  late DatabaseService databaseService;

  FavouriteMoviesPageDataController([FavouriteMoviesPageData? state])
      : super(state ?? FavouriteMoviesPageData.initial()) {
    getit = GetIt.instance;
    databaseService = getit.get<DatabaseService>();
  }

  Future<void> removeMovieFromFavourites(Movie movie) async {
    try {
      List<Movie> favouriteMovies = [];
      // Remove movie from favourites
      databaseService.removeMovieFromFavourites(movie).then(
            (_) => {
              // Get updated list of favourite movies
              databaseService.getFavouriteMovies().then(
                    (value) => {
                      // Update state
                      favouriteMovies = value,
                      state = state.copyWith(displayedMovies: favouriteMovies),
                    },
                  ),
            },
          );
    } catch (e) {
      print(e);
    }
  }
}
