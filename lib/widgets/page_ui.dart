// Packages
import 'package:flutter/material.dart';

class PageUI extends StatelessWidget {
  final double _width;
  final double _height;
  final Widget _foregroundWidget;
  final bool _isDarkTheme;
  late BuildContext _context;
  final Function(void) _onComplete;

  PageUI(
    this._width,
    this._height,
    this._foregroundWidget,
    this._isDarkTheme,
    this._onComplete,
  );

  @override
  Widget build(BuildContext context) {
    _context = context;
    return MaterialApp(
      title: 'All4Movies',
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.red,
          primarySwatch: Colors.red),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.red,
          primarySwatch: Colors.red),
      themeMode: (_isDarkTheme) ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor: Colors.black,
        body: Builder(
          builder: (BuildContext context) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _onComplete(_));
            return Container(
              width: _width,
              height: _height,
              child: Stack(
                children: [
                  _foregroundWidget,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
