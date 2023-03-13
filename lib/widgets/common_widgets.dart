// Packages
import 'package:co2509_assignment/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Models
import '../models/movie.dart';

class CommonWidgets {
  late double _width;
  late double _height;
  late BuildContext _context;

  // Basic UI found in all pages
  Widget commonUI(
    double width,
    double height,
    Widget backgroundWidget,
    Widget foregroundWidget,
    bool isDarkTheme,
    BuildContext context,
  ) {
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
      themeMode: (isDarkTheme) ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor: Colors.black,
        body: Container(
          width: width,
          height: height,
          child: Stack(
            children: [
              // backgroundWidget,
              foregroundWidget,
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton getElevatedButtons(String displayText, Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          // backgroundColor: Colors.black54,
          ),
      child: Text(displayText),
    );
  }

  DropdownMenuItem getDropDownItems(String value) {
    return DropdownMenuItem(
      value: value,
      child: Text(
        value,
        // style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
