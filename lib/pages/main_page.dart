import 'dart:ui';
// Packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
// Models
import '../models/main_page_data.dart';
import '../models/movie.dart';
import '../models/selected_category.dart';
// Widgets
import '../widgets/movie_box.dart';
import '../widgets/common_widgets.dart';
// Controller
import '../controllers/main_page_data_controller.dart';

final mainPageDataControllerProvider =
    StateNotifierProvider<MainPageDataController, MainPageData>(
  (ref) => MainPageDataController(),
);

class MainPage extends ConsumerWidget {
  MainPage({
    Key? key,
    required this.isDarkTheme,
    required this.changeLanguage,
  }) : super(key: key);

  final bool? isDarkTheme;
  bool? changeLanguage;
  double? _viewportWidth;
  double? _viewportHeight;
  TextEditingController? _searchController;

  late MainPageDataController _mainPageDataController;
  late MainPageData _mainPageData;

  late CommonWidgets _commonWidgets;
  late BuildContext _context;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _viewportWidth = MediaQuery.of(context).size.width;
    _viewportHeight = MediaQuery.of(context).size.height;
    _commonWidgets = GetIt.instance.get<CommonWidgets>();
    _context = context;

    // Monitor these providers
    // Controller
    _mainPageDataController =
        ref.watch(mainPageDataControllerProvider.notifier);
    // Data from the controller
    _mainPageData = ref.watch(mainPageDataControllerProvider);

    _searchController = TextEditingController();

    // Change language
    if (changeLanguage! == true) {
      _mainPageDataController.updateMoviesGategory(
        _mainPageData.page!,
        _mainPageData.searchCaterogy,
        true,
      );
      changeLanguage = false;
    }

    return _commonWidgets.commonUI(
      _viewportWidth!,
      _viewportHeight!,
      _backgroundWidget(),
      _foregroundWidgets(),
      isDarkTheme!,
      context,
    );
  }

  // Blurred background widget
  Widget _backgroundWidget() {
    return Container(
      width: _viewportWidth,
      height: _viewportHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: const DecorationImage(
          image: NetworkImage(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDz5Uisa_7qIZdKg6ui3F7wZ4cUlIsrNxhFvce4k3kcQ&s',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

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
            // Search bar
            _searchBarWidget(),
            // Page buttons
            _navigationButtonsWidget(),
            // Movies list view
            Container(
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
              () => {
                _mainPageDataController.updateMoviesGategory(
                  _mainPageData.page! - 1,
                  _mainPageData.searchCaterogy,
                  true,
                ),
              },
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
              () => _mainPageDataController.updateMoviesGategory(
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
      height: _viewportHeight! * 0.08,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

  Widget _searchFieldWidget() {
    final InputBorder _border = InputBorder.none;
    final String _searchText = 'Search...';

    return Container(
      width: _viewportWidth! * 0.40,
      height: _viewportHeight! * 0.05,
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
        style: const TextStyle(color: Colors.white),
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
                    _mainPageDataController.updateMoviesGategory(
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
    _sortMovies(movies, _mainPageData.sortOrder!);
    if (movies.length != 0) {
      return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, _viewportHeight! * 0.05),
            child: GestureDetector(
              // Instantiate MovieBox
              child: MovieBox(
                width: _viewportWidth! * 0.85,
                height: _viewportHeight! * 0.27, // 0.20 default
                movie: movies[index],
                // Callback to reload page
                favouriteMovieCallback: (_) =>
                    _mainPageDataController.reloadPage(),
              ),
            ),
          );
        },
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
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
