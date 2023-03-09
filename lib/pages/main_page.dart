import 'dart:ui';
// Packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Models
import '../models/movie.dart';
import '../models/search_category.dart';

// Widgets
import '../widgets/movie_box.dart';

class MainPage extends ConsumerWidget {
  late double _viewportWidth;
  late double _viewportHeight;
  late TextEditingController _searchController;

  @override
  Widget build(BuildContext context, WidgetRef watch) {
    _viewportWidth = MediaQuery.of(context).size.width;
    _viewportHeight = MediaQuery.of(context).size.height;
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
        padding: EdgeInsets.fromLTRB(0, _viewportHeight * 0.02, 0, 0),
        width: _viewportWidth * 0.95,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Search bar
            _searchBarWidget(),
            // Movies list view
            Container(
              height: _viewportHeight * 0.83,
              padding: EdgeInsets.symmetric(vertical: _viewportHeight * 0.01),
              child: _moviesListViewWidget(),
            )
          ],
        ),
      ),
    );
  }

  Widget _searchBarWidget() {
    return Container(
      height: _viewportHeight * 0.08,
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
      width: _viewportWidth * 0.50,
      height: _viewportHeight * 0.05,
      child: TextField(
        controller: _searchController,
        onSubmitted: (value) {
          print(value);
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
    String _selectedCategory = SearchCategory.popular;
    return DropdownButton(
      dropdownColor: Colors.black38,
      value: _selectedCategory,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.white24,
      ),
      onChanged: ((value) => _selectedCategory = value.toString()),
      items: [
        _getDropDownItems(SearchCategory.popular),
        _getDropDownItems(SearchCategory.upcoming),
        _getDropDownItems(SearchCategory.none),
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
    final List<Movie> movies = [];

    for (int i = 0; i < 20; i++) {
      movies.add(
        Movie(
            posterPath: "/dm06L9pxDOL9jNSK4Cb6y139rrG.jpg",
            adult: false,
            overview:
                "From DC Comics comes the Suicide Squad, an antihero team of incarcerated supervillains who act as deniable assets for the United States government, undertaking high-risk black ops missions in exchange for commuted prison sentences.",
            releaseDate: "2016-08-03",
            genreIds: [14, 28, 80],
            id: 197761,
            originalTitle: "Suicide Squad",
            originalLanguage: "en",
            title: "Suicide Squad",
            backdropPath: "/22z44LPkMyf5nyyXvv8qQLsbom.jpg",
            popularity: 48.261451,
            voteCount: 1466,
            video: false,
            voteAverage: 5.91),
      );
    }
    if (movies.isNotEmpty) {
      return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(
                vertical: _viewportHeight * 0.02, horizontal: 0),
            child: GestureDetector(
              onTap: () {
                print('Movie Tapped');
              },
              child: MovieBox(
                width: _viewportWidth * 0.85,
                height: _viewportHeight * 0.20,
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
