import 'dart:ui';
// Controllers
import '../controllers/landing_page_data_controller.dart';
// Models
import '../models/landing_page_data.dart';
// Packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
// Widgets
import '../widgets/common_widgets.dart';
// Pages
import '../pages/main_page.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _commonWidgets = GetIt.instance.get<CommonWidgets>();
    _viewportWidth = MediaQuery.of(context).size.width;
    _viewportHeight = MediaQuery.of(context).size.height;
    _context = context;

    // Monitor these providers
    // Controller
    _landingPageDataController =
        ref.watch(landingPageDataControllerProvider.notifier);
    // Data from the controller
    _landingPageData = ref.watch(landingPageDataControllerProvider);

    return _commonWidgets.commonUI(
      _viewportWidth,
      _viewportHeight,
      _backgroundWidget(),
      _foregroundWidgets(),
      _landingPageData.isDarkTheme!,
    );
  }

  // Blurred background widget
  Widget _backgroundWidget() {
    return Container(
      width: _viewportWidth,
      height: _viewportHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: const DecorationImage(
          image: NetworkImage(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDz5Uisa_7qIZdKg6ui3F7wZ4cUlIsrNxhFvce4k3kcQ&s',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

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
            _optionWidget(),
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
            () => print('Favourite Movies clicked'),
          ),
        ],
      ),
    );
  }

  Widget _optionWidget() {
    return Container(
      // color: Colors.blue,
      width: _viewportWidth * 0.95,
      margin: EdgeInsets.fromLTRB(0, _viewportHeight * 0.1, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              _themeSelectionWidget(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _themeSelectionWidget() {
    return DropdownButton(
      dropdownColor: Colors.black38,
      value: (_landingPageData.isDarkTheme!) ? 'Dark Theme' : 'Light Theme',
      icon: const Icon(
        Icons.arrow_drop_down,
      ),
      onChanged: ((selectedTheme) => _landingPageDataController.updateAppTheme(
            selectedTheme.toString(),
          )),
      items: [
        _commonWidgets.getDropDownItems('Dark Theme'),
        _commonWidgets.getDropDownItems('Light Theme'),
      ],
    );
  }
}