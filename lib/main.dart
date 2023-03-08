// Packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// Pages
import 'pages/splash_page.dart';
import 'pages/main_page.dart';

void main() {
  runApp(
    SplashPage(
      key: UniqueKey(),
      onInitComplete: () => runApp(
        ProviderScope(
          child: MainApp(),
        ),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All4Movies',
      initialRoute: 'home',
      routes: {
        'home': (BuildContext _context) => MainPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
