// Packages
import 'package:get_it/get_it.dart';

import '../services/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Models
import '../models/landing_page_data.dart';

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
    _isDarkTheme = await _firebaseService.getOnlineAppTheme();
    state = state.copyWith(
      isDarkTheme: _isDarkTheme,
    );
    _appLanguage = await _firebaseService.getOnlineAppLanguage();
    state = state.copyWith(
      appLanguage: _appLanguage,
    );
  }

  void updateAppTheme(String? appTheme) {
    bool isDarkTheme = appTheme == 'Dark Theme' ? true : false;
    if (isDarkTheme != state.isDarkTheme) {
      _firebaseService.setOnlineAppTheme(
        isDarkTheme,
        () => state = state.copyWith(
          isDarkTheme: isDarkTheme,
        ),
      );
    }
  }

  void updateAppLanguage(String? appLanguage) {
    _firebaseService.setOnlineAppLanguage(
      appLanguage!,
      () => state = state.copyWith(
        appLanguage: appLanguage,
      ),
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
