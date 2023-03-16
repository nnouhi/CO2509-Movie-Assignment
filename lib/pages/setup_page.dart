import 'dart:convert';
// Packages
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Database
import '../database/database.dart';
// Models
import '../models/app_config.dart';
// Services
import '../services/connectivity_service.dart';
import '../services/sharedpreferences_service.dart';
import '../services/database_service.dart';
import '../services/firebase_service.dart';
import '../services/http_service.dart';
import '../services/movie_service.dart';
// Widgets
import '../widgets/common_widgets.dart';
// Controllers
import '../controllers/app_manager.dart';

class SetUpPage extends StatefulWidget {
  final VoidCallback onInitComplete;

  const SetUpPage({Key? key, required this.onInitComplete}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SetUpPageState();
}

// Splash Page State
class _SetUpPageState extends State<SetUpPage> {
  @override
  void initState() {
    super.initState();

    // Callback to main app
    _setup().then(
      (_) => widget.onInitComplete(),
    );
  }

  Future<void> _setup() async {
    // Create getit instance
    final GetIt getIt = GetIt.instance;

    // Decode json file
    final dynamic configFile =
        await rootBundle.loadString('assets/config/main.json');
    final dynamic configData = jsonDecode(configFile);

    // Populate config data
    String key = configData['API_KEY'];
    String apiUrl = configData['BASE_API_URL'];
    String imageUrl = configData['BASE_IMAGE_URL'];
    String imageNotFoundUrl = configData['IMAGE_NOT_FOUND'];

    // Get Connectivity instance
    dynamic cp = Connectivity();

    // Get  SharedPreferences instance
    dynamic sp = await SharedPreferences.getInstance();

    // Initialize Database
    dynamic db =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    // Initialize Firebase
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    // Register AppConfig as singleton
    _registerSingletons(
      getIt,
      key,
      apiUrl,
      imageUrl,
      imageNotFoundUrl,
      db,
      sp,
      cp,
    );
  }

  void _registerSingletons(
    GetIt getIt,
    String key,
    String apiUrl,
    String imageUrL,
    String imageNotFoundUrl,
    dynamic db,
    dynamic sp,
    dynamic cp,
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

    // Register Update Manager as singleton
    getIt.registerSingleton<AppManager>(
      AppManager(),
    );

    // Register Connectivity Service as singleton
    getIt.registerSingleton<ConnectivityService>(
      ConnectivityService(cp),
    );

    // Register SharedPreferences Service as singleton
    getIt.registerSingleton<SharedPreferencesService>(
      SharedPreferencesService(sp),
    );

    // Register Firebase Service as singleton
    getIt.registerSingleton<FirebaseService>(
      FirebaseService(),
    );

    // Register Database Service as singleton
    getIt.registerSingleton<DatabaseService>(
      DatabaseService(db),
    );

    // Register HTTP Service as singleton
    getIt.registerSingleton<HTTPService>(
      HTTPService(),
    );

    // Register Movie Service as singleton
    getIt.registerSingleton<MovieService>(
      MovieService(),
    );

    // Register Common Service as singleton
    getIt.registerSingleton<CommonWidgets>(
      CommonWidgets(),
    );

    // Debug
    //debug();
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

  // void debug() async {
  //   final List<Movie> movies =
  //       await GetIt.instance.get<DatabaseService>().getFavouriteMovies();
  //   for (Movie movie in movies) {
  //     print(movie.title);
  //   }
  // }
}
