import 'dart:ui';
// Packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Models
import '../models/main_page_data.dart';
import '../models/movie.dart';
import '../models/selected_category.dart';
// Widgets
import '../widgets/movie_box.dart';
// Controller
import '../controllers/main_page_data_controller.dart';

final mainPageDataControllerProvider =
    StateNotifierProvider<MainPageDataController, MainPageData>(
  (ref) => MainPageDataController(),
);

class MainPage extends ConsumerWidget {
  double? _viewportWidth;
  double? _viewportHeight;
  TextEditingController? _searchController;

  late MainPageDataController _mainPageDataController;
  late MainPageData _mainPageData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _viewportWidth = MediaQuery.of(context).size.width;
    _viewportHeight = MediaQuery.of(context).size.height;

    // Monitor these providers
    // Controller
    _mainPageDataController =
        ref.watch(mainPageDataControllerProvider.notifier);
    // Data from the controller
    _mainPageData = ref.watch(mainPageDataControllerProvider);

    _searchController = TextEditingController();

    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Container(
        width: _viewportWidth,
        height: _viewportHeight,
        child: Stack(
          children: [
            _backgroundWidget(),
            _foregroundWidgets(),
          ],
        ),
      ),
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
        padding: EdgeInsets.fromLTRB(0, _viewportHeight! * 0.02, 0, 0),
        width: _viewportWidth! * 0.95,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Search bar
            _searchBarWidget(),
            // Movies list view
            Container(
              height: _viewportHeight! * 0.83,
              padding: EdgeInsets.symmetric(vertical: _viewportHeight! * 0.01),
              child: _moviesListViewWidget(),
            )
          ],
        ),
      ),
    );
  }

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
            _searchFieldWidget(),
            _categorySelectionWidget(),
          ]),
    );
  }

  Widget _searchFieldWidget() {
    final InputBorder _border = InputBorder.none;
    final String _searchText = 'Search...';

    return Container(
      width: _viewportWidth! * 0.50,
      height: _viewportHeight! * 0.05,
      child: TextField(
        controller: _searchController,
        onSubmitted: (queryText) => _mainPageDataController.updateQueryText(
          queryText,
        ),
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
      onChanged: ((selectedCategory) =>
          _mainPageDataController.updateMoviesGategory(
            selectedCategory.toString(),
          )),
      items: [
        _getDropDownItems(SelectedCategory.nowPlayingCategory),
        _getDropDownItems(SelectedCategory.popularCategory),
        _getDropDownItems(SelectedCategory.topRatedCategory),
        _getDropDownItems(SelectedCategory.upcomingCategory),
      ],
    );
  }

  DropdownMenuItem _getDropDownItems(String value) {
    return DropdownMenuItem(
      value: value,
      child: Text(
        value,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _moviesListViewWidget() {
    final List<Movie> movies = _mainPageData.displayedMovies!;
    if (movies.length != 0) {
      return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(
                vertical: _viewportHeight! * 0.02, horizontal: 0),
            child: GestureDetector(
              onTap: () {
                print('Movie Tapped');
              },
              // Instantiate MovieBox
              child: MovieBox(
                width: _viewportWidth! * 0.85,
                height: _viewportHeight! * 0.20,
                movie: movies[index],
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
