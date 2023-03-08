// Packages
import 'dart:convert';

import 'package:co2509_assignment/models/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../services/http_service.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onInitComplete;

  const SplashPage({Key? key, required this.onInitComplete}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

// Splash Page State
class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // Callback to main app
    _setup().then((_) => widget.onInitComplete());
  }

  Future<void> _setup() async {
    // Create getit instance
    final getIt = GetIt.instance;

    // Decode json file
    final configFile = await rootBundle.loadString('assets/config/main.json');
    final configData = jsonDecode(configFile);
    String key = configData['API_KEY'];
    String apiUrl = configData['BASE_API_URL'];
    String imageUrL = configData['BASE_IMAGE_URL'];

    // Register AppConfig as singleton
    getIt.registerSingleton<AppConfig>(AppConfig(
      apiKey: key,
      baseApiUrl: apiUrl,
      baseImageUrl: imageUrL,
    ));

    // Register HTTP Service as singleton
    getIt.registerSingleton<HTTPService>(HTTPService());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All4Movies',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Center(
        child: Container(
          height: 200,
          width: 200,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage('assets/images/logo.png'),
            ),
          ),
        ),
      ),
    );
  }
}
