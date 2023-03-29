// Models
import '../models/more_info_page_data.dart';
import '../models/more_info_movie.dart';
// Packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
// Controllers
import '../controllers/app_manager.dart';
import '../services/movie_service.dart';

class MoreInfoPageDataController extends StateNotifier<MoreInfoPageData> {
  MoreInfoPageDataController([MoreInfoPageData? state, int? id])
      : super(state ?? MoreInfoPageData.initial()) {
    getMoreInfoAboutMovie(id);
  }

  Future<void> getMoreInfoAboutMovie(
    int? id,
  ) async {
    try {
      bool connection = GetIt.instance.get<AppManager>().isConnected();
      if (connection) {
        MoreInfoMovie moreInfoMovie =
            await GetIt.instance.get<MovieService>().getMoreInfoAboutMovie(id!);

        state = state.copyWith(
          movie: moreInfoMovie,
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
