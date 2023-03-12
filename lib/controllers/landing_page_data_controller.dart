// Packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Models
import '../models/landing_page_data.dart';

class LandingPageDataController extends StateNotifier<LandingPageData> {
  LandingPageDataController([LandingPageData? state])
      : super(state ?? LandingPageData.initial()) {
    _getLandingPageData();
  }
  void _getLandingPageData() {}
  void updateAppTheme(String? appTheme) {
    state = state.copyWith(
      isDarkTheme: (appTheme == 'Dark Theme' ? true : false),
    );
  }
}
