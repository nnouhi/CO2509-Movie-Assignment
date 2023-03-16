import 'dart:ui';
// Packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
// Models
import '../models/movie.dart';
import '../models/selected_category.dart';
import '../models/favourite_movies_page_data.dart';
import '../models/pages.dart';
// Widgets
import '../widgets/common_widgets.dart';
import '../widgets/movie_box_remove_from_favourites.dart';
import '../widgets/page_ui.dart';
// Controller
import '../controllers/favourite_movies_page_data_controller.dart';
import '../controllers/app_manager.dart';
// Services
import '../services/connectivity_service.dart';

final favouriteMoviesPageDataControllerProvider = StateNotifierProvider<
    FavouriteMoviesPageDataController, FavouriteMoviesPageData>(
  (ref) => FavouriteMoviesPageDataController(),
);

class FavouriteMoviesPage extends ConsumerWidget {
  FavouriteMoviesPage({
    Key? key,
    required this.isDarkTheme,
  }) : super(key: key);

  final bool? isDarkTheme;
  double? _viewportWidth;
  double? _viewportHeight;

  late FavouriteMoviesPageDataController _favouriteMoviesPageDataController;
  late FavouriteMoviesPageData _favouriteMoviesPageData;

  late CommonWidgets _commonWidgets;
  late BuildContext _context;

  late AppManager _appManager;
  late ConnectivityService _connectivityService;

  late Function _onConnectivityEstablishedCallback;
  late Function _onConnectivityLostCallback;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _viewportWidth = MediaQuery.of(context).size.width;
    _viewportHeight = MediaQuery.of(context).size.height;
    _context = context;

    _commonWidgets = GetIt.instance.get<CommonWidgets>();
    _appManager = GetIt.instance.get<AppManager>();
    _connectivityService = GetIt.instance.get<ConnectivityService>();
    _appManager.setCurrentPage(Pages.FavouritesPage);

    // Callbacks
    _onConnectivityEstablishedCallback = () {};
    _onConnectivityLostCallback = () {
      _appManager.setLandingPageAsDirty(true);
      print('set landing page as dirty');
    };

    _connectivityService.setOnConnectivityEstablishedCallback(
        _onConnectivityEstablishedCallback);
    _connectivityService
        .setOnConnectivityLostCallback(_onConnectivityLostCallback);

    // Monitor these providers
    // Controller
    _favouriteMoviesPageDataController =
        ref.watch(favouriteMoviesPageDataControllerProvider.notifier);
    // Data from the controller
    _favouriteMoviesPageData =
        ref.watch(favouriteMoviesPageDataControllerProvider);

    // Check if there is an update available (for example: main page adds a movie to favourites,
    //  we need to reload this page and show the new movie)
    Function(void) _reloadCallback;
    if (_appManager.getFavouriteMoviesDirtyState()) {
      _appManager.setFavouriteMoviesAsDirty(false);
      _reloadCallback = (void _) {
        _favouriteMoviesPageDataController.reloadPage();
      };
    } else {
      _reloadCallback = (void _) {};
    }

    return PageUI(
      _viewportWidth!,
      _viewportHeight!,
      _foregroundWidgets(),
      isDarkTheme!,
      _reloadCallback,
    );
  }

  // Blurred background widget
  // Widget _backgroundWidget() {
  //   return Container(
  //     width: _viewportWidth,
  //     height: _viewportHeight,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(10.0),
  //       image: const DecorationImage(
  //         image: NetworkImage(
  //           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDz5Uisa_7qIZdKg6ui3F7wZ4cUlIsrNxhFvce4k3kcQ&s',
  //         ),
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //     child: BackdropFilter(
  //       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  //       child: Container(
  //         decoration: BoxDecoration(
  //           color: Colors.black.withOpacity(0.2),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Search bar and movies list view widget
  Widget _foregroundWidgets() {
    return Center(
      child: Container(
        // color: Colors.red,
        padding: EdgeInsets.fromLTRB(0, _viewportHeight! * 0.08, 0, 0),
        width: _viewportWidth! * 0.95,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Bar
            _topBarWidget(),
            // Movies list view
            Container(
              margin: EdgeInsets.fromLTRB(0, _viewportHeight! * 0.05, 0, 0),
              // color: Colors.black,
              height: _viewportHeight! * 0.75,
              padding: EdgeInsets.symmetric(vertical: _viewportHeight! * 0.01),
              child: _moviesListViewWidget(),
            )
          ],
        ),
      ),
    );
  }

  Widget _topBarWidget() {
    return Container(
      height: _viewportHeight! * 0.08,
      padding: EdgeInsets.fromLTRB(
          _viewportWidth! * 0.02, 0, _viewportWidth! * 0.015, 0),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _backButtonWidget(),
            const Text(
              'My Favourites',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            _sortSelectionWidget(),
          ]),
    );
  }

  Widget _backButtonWidget() {
    return // Back button
        Container(
      width: _viewportWidth! * 0.20,
      height: _viewportHeight! * 0.05,
      child: _commonWidgets.getElevatedButtons(
        'Back',
        () => {
          Navigator.pop(_context),
        },
      ),
    );
  }

  Widget _sortSelectionWidget() {
    return DropdownButton(
      dropdownColor: Colors.black38,
      value: _favouriteMoviesPageData.sortOrder,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.white24,
      ),
      onChanged: ((selectedSort) => {
            if (selectedSort != DropdownCategories.none)
              {
                if (_favouriteMoviesPageData.sortOrder != selectedSort)
                  {
                    _favouriteMoviesPageDataController.updateMoviesOrder(
                      selectedSort,
                    )
                  }
              }
          }),
      items: [
        _commonWidgets.getDropDownItems(DropdownCategories.none),
        _commonWidgets.getDropDownItems(DropdownCategories.sortAscending),
        _commonWidgets.getDropDownItems(DropdownCategories.sortDescending),
        _commonWidgets.getDropDownItems(DropdownCategories.sortDatesNewest),
        _commonWidgets.getDropDownItems(DropdownCategories.sortDatesOldest),
      ],
    );
  }

  Widget _moviesListViewWidget() {
    final List<Movie> movies = _favouriteMoviesPageData.displayedMovies!;
    _sortMovies(movies, _favouriteMoviesPageData.sortOrder!);
    if (movies.length != 0) {
      return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, _viewportHeight! * 0.05),
            child: GestureDetector(
              // Instantiate MovieBox
              child: MovieBoxRemoveFromFavourites(
                width: _viewportWidth! * 0.85,
                height: _viewportHeight! * 0.27, // 0.20 default
                movie: movies[index],
                // Callback to reload page
                favouriteMovieCallback: (_) =>
                    _favouriteMoviesPageDataController.reloadPage(),
              ),
            ),
          );
        },
      );
    } else {
      return const Center(
        child: Text(
          "No movies in favourites, add movies from the main page by clicking the 'Add to favourites button'",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  void _sortMovies(List<Movie> list, String sortOder) {
    switch (sortOder) {
      case DropdownCategories.sortAscending:
        sortMoviesByTitle(list, true);
        break;
      case DropdownCategories.sortDescending:
        sortMoviesByTitle(list, false);
        break;
      case DropdownCategories.sortDatesNewest:
        sortMoviesByDate(list, false);
        break;
      case DropdownCategories.sortDatesOldest:
        sortMoviesByDate(list, true);
        break;
      default:
        break;
    }
  }

  void sortMoviesByTitle(List<Movie> list, bool ascending) {
    if (ascending) {
      list.sort((a, b) {
        return a.title!.toLowerCase().compareTo(
              b.title!.toLowerCase(),
            );
      });
    } else {
      list.sort((a, b) {
        return b.title!.toLowerCase().compareTo(
              a.title!.toLowerCase(),
            );
      });
    }
  }

  void sortMoviesByDate(List<Movie> list, bool ascending) {
    if (ascending) {
      list.sort((a, b) {
        return a.releaseDate!.toLowerCase().compareTo(
              b.releaseDate!.toLowerCase(),
            );
      });
    } else {
      list.sort((a, b) {
        return b.releaseDate!.toLowerCase().compareTo(
              a.releaseDate!.toLowerCase(),
            );
      });
    }
  }
}
