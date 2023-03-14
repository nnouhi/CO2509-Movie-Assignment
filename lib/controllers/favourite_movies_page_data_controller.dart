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
    _getFavouriteMovies();
  }

  void reloadPage() {
    _getFavouriteMovies();
  }

  void _getFavouriteMovies() {
    List<Movie> favouriteMovies = databaseService.getFavouriteMoviesFromMap();
    state = state.copyWith(displayedMovies: favouriteMovies);
  }

  // Called from main_page.dart when user sorts the movies
  void updateMoviesOrder(String? newOrder) {
    state = state.copyWith(
      displayedMovies: state.displayedMovies,
      sortOrder: newOrder,
    );
  }

  // void reloadPage() {
  //   try {
  //     List<Movie> favouriteMovies = [];

  //     // Get updated list of favourite movies
  //     databaseService.getFavouriteMovies().then(
  //           (value) => {
  //             // Update state
  //             favouriteMovies = value,
  //             state = state.copyWith(displayedMovies: favouriteMovies),
  //           },
  //         );
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> _getFavouriteMovies() async {
  //   try {
  //     List<Movie> favouriteMovies = [];
  //     // Get favourite movies
  //     databaseService.getFavouriteMovies().then(
  //           (value) => {
  //             // Update state
  //             favouriteMovies = value,
  //             state = state.copyWith(displayedMovies: favouriteMovies),
  //           },
  //         );
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
