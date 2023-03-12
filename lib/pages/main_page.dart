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
import '../widgets/common_widgets.dart';
// Controller
import '../controllers/main_page_data_controller.dart';

final mainPageDataControllerProvider =
    StateNotifierProvider<MainPageDataController, MainPageData>(
  (ref) => MainPageDataController(),
);

class MainPage extends ConsumerWidget {
  MainPage({Key? key, required this.isDarkTheme}) : super(key: key);

  final bool? isDarkTheme;
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

    return _commonWidgets.commonUI(
      _viewportWidth!,
      _viewportHeight!,
      _backgroundWidget(),
      _foregroundWidgets(),
      isDarkTheme!,
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
        () => Navigator.pop(_context),
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
            if (selectedCategory != SelectedCategory.none)
              {
                _mainPageDataController.updateMoviesGategory(
                  1,
                  selectedCategory,
                  false,
                )
              }
          }),
      items: [
        _commonWidgets.getDropDownItems(SelectedCategory.none),
        _commonWidgets.getDropDownItems(SelectedCategory.nowPlayingCategory),
        _commonWidgets.getDropDownItems(SelectedCategory.popularCategory),
        _commonWidgets.getDropDownItems(SelectedCategory.topRatedCategory),
        _commonWidgets.getDropDownItems(SelectedCategory.upcomingCategory),
      ],
    );
  }

  Widget _moviesListViewWidget() {
    final List<Movie> movies = _mainPageData.displayedMovies!;
    if (movies.length != 0) {
      return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, _viewportHeight! * 0.05),
            child: GestureDetector(
              onTap: () {
                print('Movie Tapped');
              },
              // Instantiate MovieBox
              child: _commonWidgets.getMovieBox(
                _viewportWidth! * 0.85,
                _viewportHeight! * 0.20,
                movies[index],
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
}
