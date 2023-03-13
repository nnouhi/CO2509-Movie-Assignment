// Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
// Models
import '../models/movie.dart';
// Services
import '../services/database_service.dart';

class MovieBox extends StatelessWidget {
  final GetIt getIt = GetIt.instance;

  final double width;
  final double height;
  final Movie movie;
  final Function(void) favouriteMovieCallback;

  late BuildContext _context;

  MovieBox({
    required this.width,
    required this.height,
    required this.movie,
    required this.favouriteMovieCallback,
  });

  @override
  Widget build(BuildContext context) {
    _context = context;
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
      width: width * 0.35,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: NetworkImage(movie.getPosterUrl()),
        ),
      ),
    );
  }

  // General movie info widget
  Widget _movieInfoWidget(Function(void) favouriteMovieCallback) {
    // If movie is already in favourites, don't show the favourite button
    Widget favouriteButton =
        (getIt.get<DatabaseService>().existsInFavourites(movie.id!))
            ? Container()
            : _favouriteButtonWidget(favouriteMovieCallback);

    return Container(
      height: height,
      width: width * 0.75,
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
                width: width * 0.56,
                child: Text(
                  movie.title.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // Movie Rating
              Text(
                movie.voteAverage.toString(),
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
            ],
          ),
          // Movie language, age, release date
          Container(
            padding: EdgeInsets.fromLTRB(0, height * 0.02, 0, 0),
            child: Text(
              '${movie.originalLanguage!.toUpperCase()} | R: ${movie.adult! ? '18+' : '13+'} | ${movie.releaseDate!}',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          // Movie Overview
          Container(
            padding: EdgeInsets.fromLTRB(0, height * 0.02, 0, 0),
            child: Text(
              movie.overview!,
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
    return Container(
      padding: EdgeInsets.fromLTRB(0, height * 0.02, 0, 0),
      child: ElevatedButton(
        onPressed: () => showDialog<String>(
          context: _context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: Text(
              'Would you like to add ${movie.title} to your favourites?',
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
