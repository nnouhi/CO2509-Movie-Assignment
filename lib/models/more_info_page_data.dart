// Models

import '../models/more_info_movie.dart';

class MoreInfoPageData {
  final MoreInfoMovie movie;

  MoreInfoPageData({
    required this.movie,
  });

  MoreInfoPageData.initial() : movie = MoreInfoMovie.initial();

  MoreInfoPageData copyWith({
    MoreInfoMovie? movie,
  }) {
    return MoreInfoPageData(
      movie: movie ?? this.movie,
    );
  }
}
