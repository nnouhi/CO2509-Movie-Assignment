// Packages
import 'package:get_it/get_it.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Services
import '../services/firebase_service.dart';
// Models
import '../models/landing_page_data.dart';
import 'app_manager.dart';

class LandingPageDataController extends StateNotifier<LandingPageData> {
  late FirebaseService _firebaseService;
  late bool _isDarkTheme;
  late String _appLanguage;
  LandingPageDataController([LandingPageData? state])
      : super(state ?? LandingPageData.initial()) {
    _firebaseService = GetIt.instance.get<FirebaseService>();

    // Restore user's app theme and language once they open the app
    _getLandingPageData();
  }

  void _getLandingPageData() async {
    bool hasNetworkConnection = GetIt.instance.get<AppManager>().isConnected();
    _isDarkTheme = await _firebaseService.getOnlineAppTheme();
    _appLanguage = await _firebaseService.getOnlineAppLanguage();

    GetIt.instance.get<AppManager>().setTheme(_isDarkTheme);

    state = state.copyWith(
      isDarkTheme: _isDarkTheme,
      appLanguage: _appLanguage,
      hasNetworkConnection: hasNetworkConnection,
    );
  }

  void updateAppTheme(bool isDarkTheme) {
    _firebaseService.setOnlineAppTheme(
      isDarkTheme,
      () => {
        state = state.copyWith(
          isDarkTheme: isDarkTheme,
        ),
        GetIt.instance.get<AppManager>().setTheme(isDarkTheme),
      },
    );
  }

  void updateAppLanguage(String? appLanguage) {
    _firebaseService.setOnlineAppLanguage(
      appLanguage!,
      () => state = state.copyWith(
        appLanguage: appLanguage,
      ),
    );
  }

  void reloadPage() async {
    bool hasNetworkConnection = GetIt.instance.get<AppManager>().isConnected();
    state = state.copyWith(
      hasNetworkConnection: hasNetworkConnection,
    );
  }

  // String _getLanguageInEnglish(String appLanguage) {
  //   switch (appLanguage) {
  //     case 'English':
  //       return 'English';
  //     case 'Ελληνικά':
  //       return 'Greek';
  //     case 'Русский':
  //       return 'Russian';
  //     case 'Türkçe':
  //       return 'Turkish';
  //     case 'Français':
  //       return 'French';
  //   }

  //   return 'English';
  // }
}
