// Packages
import 'package:co2509_assignment/controllers/app_manager.dart';
import 'package:co2509_assignment/pages/more_info_page.dart';
import 'package:co2509_assignment/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
// Models
import '../models/movie.dart';
// Services
import '../services/database_service.dart';

class MovieBoxAddToFavourites extends StatelessWidget {
  final GetIt getIt = GetIt.instance;

  final double width;
  final double height;
  final Movie movie;
  final Function(void) favouriteMovieCallback;
  final Function(int) rateMovieAction;

  late BuildContext _context;

  MovieBoxAddToFavourites({
    required this.width,
    required this.height,
    required this.movie,
    required this.favouriteMovieCallback,
    required this.rateMovieAction,
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
          _movieInfoWidget(),
        ],
      ),
    );
  }

  // Movie poster (image) widget
  Widget _moviePosterWidget() {
    ImageProvider imageProvider;
    if (GetIt.instance.get<AppManager>().isConnected()) {
      // Load image from network URL
      imageProvider = NetworkImage(movie.getPosterUrl());
    } else {
      // Load image from local asset file
      imageProvider = const AssetImage('assets/images/image_not_found.jpg');
    }
    return Container(
      width: width * 0.35,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // General movie info widget
  Widget _movieInfoWidget() {
    Widget addToFavouritesButton;
    Widget rateMovieButton;
    // If movie is already in favourites, don't show the favourite button
    if (getIt.get<DatabaseService>().existsInFavourites(movie.id!)) {
      addToFavouritesButton = Container();
    } else {
      addToFavouritesButton = _addToFavouritesButtonWidget();
    }

    if (getIt.get<AppManager>().isConnected()) {
      rateMovieButton = getIt.get<CommonWidgets>().getElevatedButtons(
            'Rate Movie',
            rateMovieAction(movie.id!),
          );
    } else {
      rateMovieButton = Container();
    }

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
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${movie.originalLanguage?.toUpperCase() ?? "N/A"} | R: ${movie.adult == true ? '18+' : '13+'} | ${movie.releaseDate ?? "N/A"}',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  width: width * 0.06,
                ),
                _showMoreInfoWidget(),
              ],
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
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Add to favourite button
              addToFavouritesButton,
              rateMovieButton,
            ],
          ),
        ],
      ),
    );
  }

  Widget _showMoreInfoWidget() {
    if (GetIt.instance.get<AppManager>().isConnected()) {
      return GestureDetector(
        onTap: () => Navigator.push(
          _context,
          MaterialPageRoute(
            builder: (context) => MoreInfoPage(
              key: UniqueKey(),
              isDarkTheme: getIt.get<AppManager>().isDarkTheme(),
              movieId: movie.id!,
            ),
          ),
        ).then(
          (value) => {},
        ),
        child: const Text(
          'More Info',
          style: TextStyle(
            fontSize: 14,
            color: Colors.red,
            decoration: TextDecoration.underline,
            decorationColor: Colors.red,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  // Favourite button widget
  Widget _addToFavouritesButtonWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, height * 0.02, 0, 0),
      child: getIt.get<CommonWidgets>().getElevatedButtons('Add', () {
        showDialog<String>(
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
                  getIt.get<DatabaseService>().addFavouriteMovie(movie).then(
                        (_) => favouriteMovieCallback(_),
                      ),
                },
                child: const Text('Add'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
