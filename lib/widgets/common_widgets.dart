// Packages
import 'package:co2509_assignment/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Models
import '../models/movie.dart';

class CommonWidgets {
  late Movie _movie;
  late double _width;
  late double _height;
  late BuildContext _context;

  // Basic UI found in all pages
  Widget commonUI(
    double width,
    double height,
    Widget backgroundWidget,
    Widget foregroundWidget,
    bool isDarkTheme,
    BuildContext context,
  ) {
    _context = context;
    return MaterialApp(
      title: 'All4Movies',
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.red,
          primarySwatch: Colors.red),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.red,
          primarySwatch: Colors.red),
      themeMode: (isDarkTheme) ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor: Colors.black,
        body: Container(
          width: width,
          height: height,
          child: Stack(
            children: [
              // backgroundWidget,
              foregroundWidget,
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton getElevatedButtons(String displayText, Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          // backgroundColor: Colors.black54,
          ),
      child: Text(displayText),
    );
  }

  DropdownMenuItem getDropDownItems(String value) {
    return DropdownMenuItem(
      value: value,
      child: Text(
        value,
        // style: const TextStyle(color: Colors.white),
      ),
    );
  }

  // Movie Box widget
  Widget getMovieBox(
    double width,
    double height,
    Movie movie,
    Function(void) favouriteMovieCallback,
  ) {
    _movie = movie;
    _width = width;
    _height = height;
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _moviePosterWidget(),
          _movieInfoWidget(favouriteMovieCallback),
        ],
      ),
    );
  }

  // Movie poster (image) widget
  Widget _moviePosterWidget() {
    return Container(
      width: _width * 0.35,
      height: _height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: NetworkImage(_movie.getPosterUrl()),
        ),
      ),
    );
  }

  // General movie info widget
  Widget _movieInfoWidget(Function(void) favouriteMovieCallback) {
    // If movie is already in favourites, don't show the favourite button
    Widget favouriteButton =
        (GetIt.instance.get<DatabaseService>().existsInFavourites(_movie.id!))
            ? Container()
            : _favouriteButtonWidget(favouriteMovieCallback);

    return Container(
      height: _height,
      width: _width * 0.75,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie Title and Rating
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Movie Title
              Container(
                width: _width * 0.56,
                child: Text(
                  _movie.title.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // Movie Rating
              Text(
                _movie.voteAverage.toString(),
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
            ],
          ),
          // Movie language, age, release date
          Container(
            padding: EdgeInsets.fromLTRB(0, _height * 0.02, 0, 0),
            child: Text(
              '${_movie.originalLanguage!.toUpperCase()} | R: ${_movie.adult! ? '18+' : '13+'} | ${_movie.releaseDate!}',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          // Movie Overview
          Container(
            padding: EdgeInsets.fromLTRB(0, _height * 0.02, 0, 0),
            child: Text(
              _movie.overview!,
              maxLines: 9,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          ),
          // Add to favourite button
          favouriteButton,
        ],
      ),
    );
  }

  // Favourite button widget
  Widget _favouriteButtonWidget(Function(void) favouriteMovieCallback) {
    Movie movie = _movie;
    String title = _movie.title!;
    return Container(
      padding: EdgeInsets.fromLTRB(0, _height * 0.02, 0, 0),
      child: ElevatedButton(
        onPressed: () => showDialog<String>(
          context: _context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: Text(
              'Would you like to add ${title} to your favourites?',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.pop(context, 'Add'),
                  GetIt.instance
                      .get<DatabaseService>()
                      .addMovieToFavourites(movie)
                      .then(
                        (_) => favouriteMovieCallback(_),
                      ),
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
        style: ElevatedButton.styleFrom(
            // backgroundColor: Colors.black54,
            ),
        child: const Text(
          'Add to Favourites',
          style: TextStyle(fontSize: 10),
        ),
      ),
    );
  }
}
