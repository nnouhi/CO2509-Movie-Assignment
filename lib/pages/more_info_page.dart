import 'dart:ui';
// Packages
import 'package:co2509_assignment/controllers/more_info_page_data_controller.dart';
import 'package:co2509_assignment/models/more_info_movie.dart';
import 'package:co2509_assignment/models/more_info_page_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
// Models
import '../models/pages.dart';
// Widgets
import '../widgets/page_ui.dart';
import '../widgets/common_widgets.dart';
// Controllers
import '../controllers/app_manager.dart';
// Services
import '../services/connectivity_service.dart';

class MoreInfoPage extends ConsumerWidget {
  MoreInfoPage({
    Key? key,
    required this.isDarkTheme,
    required this.movieId,
  }) : super(key: key);

  final int? movieId;
  final bool? isDarkTheme;
  late final moreInfoPageDataControllerProvider =
      StateNotifierProvider<MoreInfoPageDataController, MoreInfoPageData>(
    (ref) => MoreInfoPageDataController(
      MoreInfoPageData.initial(),
      movieId,
    ),
  );
  double? _viewportWidth;
  double? _viewportHeight;
  late MoreInfoMovie? _movie;

  late MoreInfoPageDataController _moreInfoPageDataController;
  late MoreInfoPageData _moreInfoPageData;

  late CommonWidgets _commonWidgets;
  late BuildContext _context;

  late AppManager _appManager;
  late ConnectivityService _connectivityService;

  late Function _onConnectivityEstablishedCallback;
  late Function _onConnectivityLostCallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _viewportWidth = MediaQuery.of(context).size.width;
    _viewportHeight = MediaQuery.of(context).size.height;
    _context = context;

    _commonWidgets = GetIt.instance.get<CommonWidgets>();
    _appManager = GetIt.instance.get<AppManager>();
    _connectivityService = GetIt.instance.get<ConnectivityService>();
    _appManager.setCurrentPage(Pages.MoreInfoPage);

    // Callbacks
    _onConnectivityEstablishedCallback = () {
      _moreInfoPageDataController.getMoreInfoAboutMovie(movieId);
    };
    _onConnectivityLostCallback = () {
      _appManager.setLandingPageAsDirty(true);

      // Show connection lost dialog
      showDialog<String>(
        context: _context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Connection lost'),
          content: Text(
            'No connection to the internet.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Okay'),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    };

    // Set Callbacks
    _connectivityService.setOnConnectivityEstablishedCallback(
        _onConnectivityEstablishedCallback);
    _connectivityService
        .setOnConnectivityLostCallback(_onConnectivityLostCallback);

    // Monitor these providers
    // Controller
    _moreInfoPageDataController =
        ref.watch(moreInfoPageDataControllerProvider.notifier);
    // Data from the controller
    _moreInfoPageData = ref.watch(moreInfoPageDataControllerProvider);

    return PageUI(
      _viewportWidth!,
      _viewportHeight!,
      _foregroundWidgets(),
      isDarkTheme!,
      (void _) {},
    );
  }

  // Search bar and movies list view widget
  Widget _foregroundWidgets() {
    _movie = _moreInfoPageData.movie;
    if (_movie != null && _movie!.id != -1) {
      return Center(
        child: Container(
          // color: Colors.red,
          padding: EdgeInsets.fromLTRB(_viewportWidth! * 0.02,
              _viewportHeight! * 0.08, _viewportWidth! * 0.02, 0),
          // width: _viewportWidth! * 0.95,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Bar
              _topBarWidget(),
              // Movies list view
              Container(
                // color: Colors.red,
                height: _viewportHeight! * 0.75,
                padding:
                    EdgeInsets.symmetric(vertical: _viewportHeight! * 0.01),
                child: _movieBoxWidget(),
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'Cannot found more information on this movie.',
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _topBarWidget() {
    return Container(
      // height: _viewportHeight! * 0.08,
      padding: EdgeInsets.fromLTRB(
          _viewportWidth! * 0.02, 0, _viewportWidth! * 0.02, 0),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _backButtonWidget(),
          Expanded(
            child: Center(
              child: const Text(
                'Extra Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _movieBoxWidget() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _moviePosterWidget(),
        SizedBox(height: _viewportHeight! * 0.01),
        _movieInfoWidget(),
      ],
    );
  }

  // Movie poster (image) widget
  Widget _moviePosterWidget() {
    ImageProvider imageProvider;
    if (GetIt.instance.get<AppManager>().isConnected()) {
      // Load image from network URL
      imageProvider = NetworkImage(_movie!.getPosterUrl());
    } else {
      // Load image from local asset file
      imageProvider = const AssetImage('assets/images/image_not_found.jpg');
    }
    return Container(
      width: _viewportWidth! * 0.75,
      height: _viewportHeight! * 0.25,
      padding: EdgeInsets.symmetric(horizontal: _viewportWidth! * 0.04),
      // color: Colors.red,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget _movieInfoWidget() {
    return Flexible(
      child: SingleChildScrollView(
        child: Container(
          width: _viewportWidth! * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationThickness: 2,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: _viewportHeight! * 0.02),
              Text(
                _movie!.overview ?? 'N/A',
                style: const TextStyle(
                  fontSize: 16,
                ),
                maxLines: 7,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: _viewportHeight! * 0.02),
              const Text(
                'Original Language | Age Rating | Release Date | Vote Average',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationThickness: 2,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: _viewportHeight! * 0.02),
              Text(
                '${_movie?.originalLanguage?.toUpperCase() ?? "N/A"} | R: ${_movie?.adult == true ? '18+' : '13+'} | ${_movie?.releaseDate ?? "N/A"} | ${_movie?.voteAverage ?? "N/A"}',
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: _viewportHeight! * 0.02),
              const Text(
                'Genres',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationThickness: 2,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: _viewportHeight! * 0.02),
              Text(
                _movie!.getGenres(),
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: _viewportHeight! * 0.02),
              const Text(
                'Runtime | Budget | Revenue ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationThickness: 2,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: _viewportHeight! * 0.02),
              Text(
                '${_movie!.getRuntime()} | ${_movie!.getInCurrencyFormat(_movie!.budget!)} | ${_movie!.getInCurrencyFormat(_movie!.revenue!)}',
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backButtonWidget() {
    return Container(
      // width: _viewportWidth! * 0.20,
      // height: _viewportHeight! * 0.05,
      child: _commonWidgets.getElevatedButtons(
        'Back',
        () => {
          Navigator.pop(_context),
        },
      ),
    );
  }
}
