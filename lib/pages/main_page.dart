import 'dart:ui';
// Packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
// Models
import '../models/main_page_data.dart';
import '../models/movie.dart';
import '../models/pages.dart';
import '../models/selected_category.dart';
// Widgets
import '../widgets/page_ui.dart';
import '../widgets/movie_box_add_to_favourites.dart';
import '../widgets/common_widgets.dart';
// Controllers
import '../controllers/main_page_data_controller.dart';
import '../controllers/app_manager.dart';
// Services
import '../services/connectivity_service.dart';

final mainPageDataControllerProvider =
    StateNotifierProvider<MainPageDataController, MainPageData>(
  (ref) => MainPageDataController(),
);

class MainPage extends ConsumerWidget {
  MainPage({
    Key? key,
    required this.isDarkTheme,
  }) : super(key: key);

  final bool? isDarkTheme;
  double? _viewportWidth;
  double? _viewportHeight;

  TextEditingController? _searchController;
  TextEditingController? _rateMovieController;

  late MainPageDataController _mainPageDataController;
  late MainPageData _mainPageData;

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
    _appManager.setCurrentPage(Pages.MainPage);

    // Callbacks
    _onConnectivityEstablishedCallback = () {
      _mainPageDataController.updateMoviesCategory(
        _mainPageData.page!,
        _mainPageData.searchCaterogy,
        true,
      );
    };
    _onConnectivityLostCallback = () {
      _appManager.setLandingPageAsDirty(true);
      // Show connection lost dialog
      showDialog<String>(
        context: _context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Connection lost'),
          content: Text(
            'No connection to the internet. You can only browse the first page of each category.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Okay'),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      _mainPageDataController.updateMoviesCategory(
        _mainPageData.page!,
        _mainPageData.searchCaterogy,
        true,
      );
    };

    // Set Callbacks
    _connectivityService.setOnConnectivityEstablishedCallback(
        _onConnectivityEstablishedCallback);
    _connectivityService
        .setOnConnectivityLostCallback(_onConnectivityLostCallback);

    // Monitor these providers
    // Controller
    _mainPageDataController =
        ref.watch(mainPageDataControllerProvider.notifier);
    // Data from the controller
    _mainPageData = ref.watch(mainPageDataControllerProvider);

    _searchController = TextEditingController();
    _rateMovieController = TextEditingController();

    // Check if there was an update and reload the page
    // For example if the user changed language from landing page
    Function(void) _reloadCallback;
    if (_appManager.getMainPageDirtyState()) {
      _appManager.setMainPageAsDirty(false);
      _reloadCallback = (void _) {
        _mainPageDataController.updateMoviesCategory(
          _mainPageData.page!,
          _mainPageData.searchCaterogy,
          true,
        );
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
    return SingleChildScrollView(
      child: Center(
        child: Container(
          // color: Colors.yellow,
          padding: EdgeInsets.fromLTRB(_viewportWidth! * 0.02,
              _viewportHeight! * 0.08, _viewportWidth! * 0.02, 0),
          // width: double.maxFinite,
          // height: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Search bar
              _searchBarWidget(),
              // Page buttons
              _navigationButtonsWidget(),
              // Movies list view
              Container(
                // color: Colors.red,
                height: _viewportHeight! * 0.75,
                padding:
                    EdgeInsets.symmetric(vertical: _viewportHeight! * 0.01),
                child: _moviesListViewWidget(),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Page button widget
  Widget _navigationButtonsWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: _viewportHeight! * 0.01),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Previous Page
            _commonWidgets.getElevatedButtons(
              '<',
              () => _mainPageDataController.updateMoviesCategory(
                _mainPageData.page! - 1,
                _mainPageData.searchCaterogy,
                true,
              ),
            ),
            Text(
              'Page: ${_mainPageData.page} / ${_mainPageData.totalPages}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            // Next Page
            _commonWidgets.getElevatedButtons(
              '>',
              () => _mainPageDataController.updateMoviesCategory(
                _mainPageData.page! + 1,
                _mainPageData.searchCaterogy,
                true,
              ),
            ),
            _sortSelectionWidget(),
          ],
        ),
      ),
    );
  }

  // Search bar widgets
  Widget _searchBarWidget() {
    return Container(
      // height: _viewportHeight! * 0.08,
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
            _searchFieldWidget(),
            _categorySelectionWidget(),
          ]),
    );
  }

  Widget _backButtonWidget() {
    return // Back button
        Container(
      // width: _viewportWidth! * 0.20,
      // height: _viewportHeight! * 0.05,
      child: _commonWidgets.getElevatedButtons(
        'Back',
        () => {
          Navigator.pop(_context),
        },
      ),
    );
  }

  Widget _searchFieldWidget() {
    final InputBorder _border = InputBorder.none;
    final String _searchText = 'Search...';

    return Container(
      width: _viewportWidth! * 0.40,
      // height: _viewportHeight! * 0.05,
      child: TextField(
        controller: _searchController,
        onSubmitted: (queryText) => {
          if (queryText.isNotEmpty)
            {
              _mainPageDataController.updateQueryText(
                queryText,
              )
            }
        },
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
            focusedBorder: _border,
            border: _border,
            prefixIcon: const Icon(Icons.search, color: Colors.white24),
            hintStyle: const TextStyle(color: Colors.white24),
            filled: false,
            fillColor: Colors.white24,
            hintText: _searchText),
      ),
    );
  }

  Widget _categorySelectionWidget() {
    return DropdownButton(
      dropdownColor: Colors.black38,
      value: _mainPageData.searchCaterogy,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.white24,
      ),
      onChanged: ((selectedCategory) => {
            if (selectedCategory != DropdownCategories.none)
              {
                if (selectedCategory != _mainPageData.searchCaterogy)
                  {
                    _mainPageDataController.updateMoviesCategory(
                      1,
                      selectedCategory,
                      false,
                    )
                  }
              }
          }),
      items: [
        _commonWidgets.getDropDownItems(DropdownCategories.none),
        _commonWidgets.getDropDownItems(DropdownCategories.nowPlayingCategory),
        _commonWidgets.getDropDownItems(DropdownCategories.popularCategory),
        _commonWidgets.getDropDownItems(DropdownCategories.topRatedCategory),
        _commonWidgets.getDropDownItems(DropdownCategories.upcomingCategory),
      ],
    );
  }

  Widget _sortSelectionWidget() {
    return DropdownButton(
      dropdownColor: Colors.black38,
      value: _mainPageData.sortOrder,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.white24,
      ),
      onChanged: ((selectedSort) => {
            if (selectedSort != DropdownCategories.none)
              {
                if (_mainPageData.sortOrder != selectedSort)
                  {
                    _mainPageDataController.updateMoviesOrder(
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
    final List<Movie> movies = _mainPageData.displayedMovies!;
    sortMovies(movies, _mainPageData.sortOrder!);
    if (movies.length != 0) {
      return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, _viewportHeight! * 0.05),
            child: GestureDetector(
              // Instantiate MovieBox
              child: MovieBoxAddToFavourites(
                width: _viewportWidth! * 0.85,
                height: _viewportHeight! * 0.27, // 0.20 default
                movie: movies[index],
                // Callback to reload page
                favouriteMovieCallback: (_) => {
                  _appManager.setFavouriteMoviesAsDirty(true),
                  _mainPageDataController.reloadPage()
                },
                rateMovieAction: (movieId) => rateMovieAction(movieId),
              ),
            ),
          );
        },
      );
    } else {
      return Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'No movies found...',
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ],
          ),
        ),
      );
    }
  }

  Function rateMovieAction(int movieId) {
    return () => showDialog<String>(
          context: _context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Rate Movie From 0.5 - 10'),
            content: TextField(
              decoration: const InputDecoration(hintText: 'Rate movie...'),
              enabled: true,
              controller: _rateMovieController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp('[\\-|\\ ]'))
              ],
              onSubmitted: (value) => {
                if (value.isNotEmpty)
                  {
                    // clear value
                    if (double.parse(value) >= 0.5 && double.parse(value) <= 10)
                      {
                        _mainPageDataController
                            .rateMovie(
                              movieId,
                              double.parse(value),
                            )
                            .then(
                              (success) => {
                                if (success)
                                  {
                                    // Show success
                                    showDialog<String>(
                                      context: _context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text(
                                            'Movie rated sucessfully, thank you'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'Okay'),
                                            child: const Text('Okay'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  }
                                else
                                  {
                                    // TODO Show error
                                  }
                              },
                            ),
                      }
                    else
                      {
                        // Out of range error
                        showDialog<String>(
                          context: _context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                              'Please enter a value between 0.5 and 10',
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Okay'),
                                child: const Text('Okay'),
                              ),
                            ],
                          ),
                        ),
                      }
                  },
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Close'),
                child: const Text('Close'),
              ),
            ],
          ),
        );
  }

  void sortMovies(List<Movie> list, String sortOder) {
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
      list.sort(
        (a, b) {
          return a.title!.toLowerCase().compareTo(
                b.title!.toLowerCase(),
              );
        },
      );
    } else {
      list.sort(
        (a, b) {
          return b.title!.toLowerCase().compareTo(
                a.title!.toLowerCase(),
              );
        },
      );
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
