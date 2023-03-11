// Packages
import 'dart:convert';
import 'package:co2509_assignment/services/movie_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../models/app_config.dart';

// Services
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
    final GetIt getIt = GetIt.instance;

    // Decode json file
    final dynamic configFile =
        await rootBundle.loadString('assets/config/main.json');
    final dynamic configData = jsonDecode(configFile);
    String key = configData['API_KEY'];
    String apiUrl = configData['BASE_API_URL'];
    String imageUrl = configData['BASE_IMAGE_URL'];
    String imageNotFoundUrl = configData['IMAGE_NOT_FOUND'];

    // Register AppConfig as singleton
    _registerSingletons(getIt, key, apiUrl, imageUrl, imageNotFoundUrl);
  }

  void _registerSingletons(
    GetIt getIt,
    String key,
    String apiUrl,
    String imageUrL,
    String imageNotFoundUrl,
  ) {
    // Register AppConfig as singleton
    getIt.registerSingleton<AppConfig>(
      AppConfig(
        apiKey: key,
        baseApiUrl: apiUrl,
        baseImageUrl: imageUrL,
        imageNotFoundUrl: imageNotFoundUrl,
      ),
    );

    // Register HTTP Service as singleton
    getIt.registerSingleton<HTTPService>(
      HTTPService(),
    );

    // Register Movie Service as singleton
    getIt.registerSingleton<MovieService>(
      MovieService(),
    );
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
