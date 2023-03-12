// Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Models
import '../models/movie.dart';

class CommonWidgets {
  late Movie _movie;
  late double _width;
  late double _height;

  // Basic UI found in all pages
  Widget commonUI(
    double width,
    double height,
    Widget backgroundWidget,
    Widget foregroundWidget,
  ) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Container(
        width: width,
        height: height,
        child: Stack(
          children: [
            backgroundWidget,
            foregroundWidget,
          ],
        ),
      ),
    );
  }

  ElevatedButton getElevatedButtons(String displayText, Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black54,
      ),
      child: Text(displayText),
    );
  }

  // Movie Box widget
  Widget getMovieBox(double width, double height, Movie movie) {
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
          _movieInfoWidget(),
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
  Widget _movieInfoWidget() {
    return Container(
      height: _height,
      width: _width * 0.75,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
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
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // Movie Rating
              Text(
                _movie.voteAverage.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 22),
              ),
            ],
          ),
          // Movie language, age, release date
          Container(
            padding: EdgeInsets.fromLTRB(0, _height * 0.02, 0, 0),
            child: Text(
                '${_movie.originalLanguage!.toUpperCase()} | R: ${_movie.adult! ? '18+' : '13+'} | ${_movie.releaseDate!}',
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
          // Movie Overview
          Container(
            padding: EdgeInsets.fromLTRB(0, _height * 0.02, 0, 0),
            child: Text(
              _movie.overview!,
              maxLines: 9,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          )
        ],
      ),
    );
  }
}
