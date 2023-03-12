// Packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// Pages
import '../pages/setup_page.dart';
import '../pages/main_page.dart';
import '../pages/landing_page.dart';

void main() {
  runApp(
    SetUpPage(
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
        // 'home': (BuildContext context) => MainPage(),
        'home': (BuildContext context) => LandingPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
