import 'dart:ui';
// Controllers
import '../controllers/app_manager.dart';
import '../controllers/landing_page_data_controller.dart';
// Models
import '../models/landing_page_data.dart';
// Packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
// Widgets
import '../models/pages.dart';
import '../widgets/page_ui.dart';
import '../widgets/common_widgets.dart';
// Pages
import '../pages/main_page.dart';
import '../pages/favourite_movies_page.dart';
// Services
import '../services/connectivity_service.dart';

final landingPageDataControllerProvider =
    StateNotifierProvider<LandingPageDataController, LandingPageData>(
  (ref) => LandingPageDataController(),
);

class LandingPage extends ConsumerWidget {
  late CommonWidgets _commonWidgets;

  late LandingPageDataController _landingPageDataController;
  late LandingPageData _landingPageData;

  late double _viewportWidth;
  late double _viewportHeight;

  late BuildContext _context;

  late AppManager _appManager;
  late ConnectivityService _connectivityService;

  late Function _onConnectivityEstablishedCallback;
  late Function _onConnectivityLostCallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _commonWidgets = GetIt.instance.get<CommonWidgets>();
    _appManager = GetIt.instance.get<AppManager>();
    _connectivityService = GetIt.instance.get<ConnectivityService>();
    _appManager.setCurrentPage(Pages.LandingPage);

    _viewportWidth = MediaQuery.of(context).size.width;
    _viewportHeight = MediaQuery.of(context).size.height;
    _context = context;

    // Monitor these providers
    // Controller
    _landingPageDataController =
        ref.watch(landingPageDataControllerProvider.notifier);
    // Data from the controller
    _landingPageData = ref.watch(landingPageDataControllerProvider);

    // Callbacks for when the connectivity changes
    _onConnectivityEstablishedCallback = () {
      _landingPageDataController.reloadPage();
    };
    _onConnectivityLostCallback = () {
      _landingPageDataController.reloadPage();
    };

    // Set the callbacks
    _connectivityService.setOnConnectivityEstablishedCallback(
        _onConnectivityEstablishedCallback);
    _connectivityService
        .setOnConnectivityLostCallback(_onConnectivityLostCallback);

    // Check if there is an update available (for example: main page adds a movie to favourites,
    //  we need to reload this page and show the new movie)
    Function(void) _reloadCallback;
    if (_appManager.getLandingPageDirtyState()) {
      _appManager.setLandingPageAsDirty(false);
      _reloadCallback = (void _) {
        _landingPageDataController.reloadPage();
      };
    } else {
      _reloadCallback = (void _) {};
    }

    // Build the UI
    return PageUI(
      _viewportWidth,
      _viewportHeight,
      _foregroundWidgets(),
      _landingPageData.isDarkTheme!,
      _reloadCallback,
    );
  }

  // Blurred background widget
  // Widget _backgroundWidget() {
  //   return Container(
  //     width: _viewportWidth,
  //     height: _viewportHeight,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(10.0),
  //       image: const DecorationImage(
  //         image: NetworkImage(
  //           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDz5Uisa_7qIZdKg6ui3F7wZ4cUlIsrNxhFvce4k3kcQ&s',
  //         ),
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //     child: BackdropFilter(
  //       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  //       child: Container(
  //         decoration: BoxDecoration(
  //           color: Colors.black.withOpacity(0.2),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _foregroundWidgets() {
    Widget hasNetworkConnectionWidget;
    if (_appManager.isConnected()) {
      hasNetworkConnectionWidget = Text('');
    } else {
      hasNetworkConnectionWidget = _hasInternetConnectionWidget();
    }

    return Center(
      child: Container(
        // color: Colors.red,
        padding: EdgeInsets.fromLTRB(0, _viewportHeight * 0.20, 0, 0),
        width: _viewportWidth * 0.95,
        child: ListView(
          children: [
            _titleWidget(),
            _buttonsWidget(),
            _optionsWidget(),
            hasNetworkConnectionWidget,
          ],
        ),
      ),
    );
  }

  Widget _hasInternetConnectionWidget() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text(
          'No Network Connection',
          style: TextStyle(
              color: Colors.yellow, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          'Features are limited',
          style: TextStyle(
              color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          '(Cannot rate a movie, you are allowed to view only the first page of each category)',
          style: TextStyle(color: Colors.yellow, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _titleWidget() {
    return Container(
      // color: Colors.black,
      width: _viewportWidth * 0.95,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          // Title
          Text(
            'Welcome to All4Movies',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Subtitle
          Text(
            'Click any of the below buttons to get started',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonsWidget() {
    return Container(
      // color: Colors.yellow,
      width: _viewportWidth * 0.95,
      margin: EdgeInsets.fromLTRB(0, _viewportHeight * 0.1, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Browse Our Pages',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          _commonWidgets.getElevatedButtons(
            'Movie Page',
            () => Navigator.push(
              _context,
              MaterialPageRoute(
                builder: (context) => MainPage(
                  key: UniqueKey(),
                  isDarkTheme: _landingPageData.isDarkTheme!,
                ),
              ),
            ).then(
              (value) => {
                _landingPageDataController.reloadPage(),
              },
            ),
          ),
          _commonWidgets.getElevatedButtons(
            'Favourite Movies Page',
            () => Navigator.push(
              _context,
              MaterialPageRoute(
                builder: (context) => FavouriteMoviesPage(
                  key: UniqueKey(),
                  isDarkTheme: _landingPageData.isDarkTheme!,
                ),
              ),
            ).then(
              (value) => {
                _landingPageDataController.reloadPage(),
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionsWidget() {
    return Container(
      // color: Colors.blue,
      width: _viewportWidth * 0.95,
      margin: EdgeInsets.fromLTRB(0, _viewportHeight * 0.1, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'App Preferences',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: _viewportHeight * 0.03,
                  ),
                  const Text(
                    'Application Theme',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _themeSelectionWidget(),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: _viewportHeight * 0.03, // <-- SEE HERE
                  ),
                  const Text(
                    'Application Language',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _languageSelectionWidget(),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _themeSelectionWidget() {
    bool isDarkTheme;
    return DropdownButton(
      dropdownColor: Colors.black38,
      value: (_landingPageData.isDarkTheme!) ? 'Dark Theme' : 'Light Theme',
      icon: const Icon(
        Icons.arrow_drop_down,
      ),
      onChanged: ((selectedTheme) => {
            // Don't update the theme if the selected theme is the same as the current theme
            isDarkTheme = (selectedTheme == 'Dark Theme') ? true : false,
            if (isDarkTheme != _landingPageData.isDarkTheme)
              {
                _landingPageDataController.updateAppTheme(
                  isDarkTheme,
                )
              },
          }),
      items: [
        _commonWidgets.getDropDownItems('Dark Theme'),
        _commonWidgets.getDropDownItems('Light Theme'),
      ],
    );
  }

  Widget _languageSelectionWidget() {
    return DropdownButton(
      dropdownColor: Colors.black38,
      value: _landingPageData.appLanguage,
      icon: const Icon(
        Icons.arrow_drop_down,
      ),
      onChanged: ((selectedLanguage) => {
            // Don't update the language if the selected language is the same as the current language
            if (selectedLanguage.toString() != _landingPageData.appLanguage)
              {
                _appManager.setMainPageAsDirty(true),
                _landingPageDataController
                    .updateAppLanguage(selectedLanguage.toString())
              }
          }),
      items: [
        _commonWidgets.getDropDownItems('English'),
        _commonWidgets.getDropDownItems('Ελληνικά'),
        _commonWidgets.getDropDownItems('Русский'),
        _commonWidgets.getDropDownItems('Türkçe'),
        _commonWidgets.getDropDownItems('Français'),
      ],
    );
  }
}
