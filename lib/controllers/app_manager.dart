// Models
import '../models/pages.dart';
// Packages
import 'package:connectivity_plus/connectivity_plus.dart';

class AppManager {
  late bool _favouriteMoviesUpdater;
  late bool _mainPageUpdater;
  late bool _landingPageUpdater;
  late Pages _currentPage;
  late bool _isConnected;
  late bool _darkTheme;

  AppManager() {
    _favouriteMoviesUpdater = false;
    _mainPageUpdater = false;
    _landingPageUpdater = false;
    _currentPage = Pages.LandingPage;
    _isConnected = false;
    _darkTheme = false;
  }

  // Favourite Movies Page
  bool getFavouriteMoviesDirtyState() => _favouriteMoviesUpdater;
  void setFavouriteMoviesAsDirty(bool isDirty) =>
      _favouriteMoviesUpdater = isDirty;

  // Main Page
  bool getMainPageDirtyState() => _mainPageUpdater;
  void setMainPageAsDirty(bool isDirty) => _mainPageUpdater = isDirty;

  // Landing page
  bool getLandingPageDirtyState() => _landingPageUpdater;
  void setLandingPageAsDirty(bool isDirty) => _landingPageUpdater = isDirty;

  // Current Page
  Pages getCurrentPage() => _currentPage;
  void setCurrentPage(Pages page) => _currentPage = page;

  // Connection state
  bool isConnected() => _isConnected;
  void setConnectionState(ConnectivityResult connectivityResult) {
    if (connectivityResult != ConnectivityResult.none) {
      _isConnected = true;
    } else {
      _isConnected = false;
    }
  }

  // Dark Theme
  bool isDarkTheme() => _darkTheme;
  void setTheme(bool isDarkTheme) => _darkTheme = isDarkTheme;
}
