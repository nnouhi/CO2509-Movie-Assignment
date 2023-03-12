import 'dart:ui';
// Packages
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
// Widgets
import '../widgets/common_widgets.dart';
// Pages
import '../pages/main_page.dart';

class LandingPage extends StatelessWidget {
  late CommonWidgets _commonWidgets;
  late double _viewportWidth;
  late double _viewportHeight;

  @override
  Widget build(BuildContext context) {
    _commonWidgets = GetIt.instance.get<CommonWidgets>();
    _viewportWidth = MediaQuery.of(context).size.width;
    _viewportHeight = MediaQuery.of(context).size.height;
    return _commonWidgets.commonUI(
      _viewportWidth,
      _viewportHeight,
      _backgroundWidget(),
      _foregroundWidgets(context),
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

  Widget _foregroundWidgets(BuildContext context) {
    return Center(
      child: Container(
        // color: Colors.red,
        padding: EdgeInsets.fromLTRB(0, _viewportHeight * 0.3, 0, 0),
        width: _viewportWidth * 0.95,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _titleWidget(),
            _buttonsContainer(context),
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
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Subtitle
          Text(
            'Click any of the below buttons to get started',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonsContainer(BuildContext context) {
    return Container(
      // color: Colors.yellow,
      width: _viewportWidth * 0.95,
      margin: EdgeInsets.fromLTRB(0, _viewportHeight * 0.1, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _commonWidgets.getElevatedButtons(
            'Options Page',
            () => print('Option Page clicked'),
          ),
          _commonWidgets.getElevatedButtons(
            'Movie Page',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainPage(),
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
}
