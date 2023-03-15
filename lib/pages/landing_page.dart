import 'dart:ui';
// Controllers
import '../controllers/update_manager.dart';
import '../controllers/landing_page_data_controller.dart';
// Models
import '../models/landing_page_data.dart';
// Packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
// Widgets
import '../widgets/page_ui.dart';
import '../widgets/common_widgets.dart';
// Pages
import '../pages/main_page.dart';
import '../pages/favourite_movies_page.dart';

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

  late UpdateManager _updateManager;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _commonWidgets = GetIt.instance.get<CommonWidgets>();
    _updateManager = GetIt.instance.get<UpdateManager>();

    _viewportWidth = MediaQuery.of(context).size.width;
    _viewportHeight = MediaQuery.of(context).size.height;
    _context = context;

    // Monitor these providers
    // Controller
    _landingPageDataController =
        ref.watch(landingPageDataControllerProvider.notifier);
    // Data from the controller
    _landingPageData = ref.watch(landingPageDataControllerProvider);

    // Build the UI
    return PageUI(
      _viewportWidth,
      _viewportHeight,
      _foregroundWidgets(),
      _landingPageData.isDarkTheme!,
      (_) => null,
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
    return Center(
      child: Container(
        // color: Colors.red,
        padding: EdgeInsets.fromLTRB(0, _viewportHeight * 0.27, 0, 0),
        width: _viewportWidth * 0.95,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _titleWidget(),
            _buttonsWidget(),
            _optionsWidget(),
          ],
        ),
      ),
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
                _updateManager.setMainPageAsDirty(true),
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
