// Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Models
import '../models/movie.dart';

class MovieBox extends StatelessWidget {
  final GetIt getIt = GetIt.instance;

  final double width;
  final double height;
  final Movie movie;

  MovieBox({
    required this.width,
    required this.height,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _moviePosterWidget(movie.getPosterUrl()),
          _movieInfoWidget(),
        ],
      ),
    );
  }

  // Movie poster (image) widget
  Widget _moviePosterWidget(String posterUrl) {
    return Container(
      width: width * 0.35,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: NetworkImage(posterUrl),
        ),
      ),
    );
  }

  // General movie info widget
  Widget _movieInfoWidget() {
    return Container(
      height: height,
      width: width * 0.75,
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
                width: width * 0.56,
                child: Text(
                  movie.title.toString(),
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
                movie.voteAverage.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 22),
              ),
            ],
          ),
          // Movie language, age, release date
          Container(
            padding: EdgeInsets.fromLTRB(0, height * 0.02, 0, 0),
            child: Text(
                '${movie.originalLanguage!.toUpperCase()} | R: ${movie.adult! ? '18+' : '13+'} | ${movie.releaseDate!}',
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
          // Movie Overview
          Container(
            padding: EdgeInsets.fromLTRB(0, height * 0.02, 0, 0),
            child: Text(
              movie.overview!,
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
