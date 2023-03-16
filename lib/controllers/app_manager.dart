// Models
import 'package:flutter/cupertino.dart';

import '../models/pages.dart';
// Packages
import 'package:connectivity_plus/connectivity_plus.dart';

class AppManager {
  bool _favouriteMoviesUpdater = false;
  bool _mainPageUpdater = false;
  bool _landingPageUpdater = false;
  Pages _currentPage = Pages.LandingPage;
  bool _isConnected = false;

  AppManager();
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
}
