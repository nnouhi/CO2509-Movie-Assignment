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
  LandingPageDataController([LandingPageData? state])
      : super(state ?? LandingPageData.initial()) {
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _getLandingPageData();
  }
  void _getLandingPageData() async {
    _isDarkTheme = await _firebaseService.getOnlineAppTheme();
    state = state.copyWith(
      isDarkTheme: _isDarkTheme,
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
}
