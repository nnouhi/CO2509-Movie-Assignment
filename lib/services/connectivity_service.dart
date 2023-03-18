// Packages
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:get_it/get_it.dart';
// Controllers
import '../controllers/app_manager.dart';
// Models
import '../models/pages.dart';

class ConnectivityService {
  final Connectivity _connectivity;
  late StreamSubscription<ConnectivityResult> _subscription;
  // Callbacks
  late Function _onConnectivityEstablishedCallbackFavouriteMovies;
  late Function _onConnectivityEstablishedCallbackLandingPage;
  late Function _onConnectivityEstablishedCallbackMainPage;

  late Function _onConnectivityLostCallbackFavouriteMovies;
  late Function _onConnectivityLostCallbackLandingPage;
  late Function _onConnectivityLostCallbackMainPage;

  ConnectivityResult _previousResult = ConnectivityResult.none;
  bool isInitialized = false;

  ConnectivityService(this._connectivity);

  void subscribe() {
    _subscription =
        _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
  }

  void setOnConnectivityEstablishedCallback(Function callback) {
    Pages currentPage = GetIt.instance.get<AppManager>().getCurrentPage();
    switch (currentPage) {
      case Pages.LandingPage:
        _onConnectivityEstablishedCallbackLandingPage = callback;
        break;
      case Pages.MainPage:
        _onConnectivityEstablishedCallbackMainPage = callback;
        break;
      case Pages.FavouritesPage:
        _onConnectivityEstablishedCallbackFavouriteMovies = callback;
        break;
    }
  }

  void setOnConnectivityLostCallback(Function callback) {
    Pages currentPage = GetIt.instance.get<AppManager>().getCurrentPage();
    switch (currentPage) {
      case Pages.LandingPage:
        _onConnectivityLostCallbackLandingPage = callback;
        break;
      case Pages.MainPage:
        _onConnectivityLostCallbackMainPage = callback;
        break;
      case Pages.FavouritesPage:
        _onConnectivityLostCallbackFavouriteMovies = callback;
        break;
    }
  }

  void _onConnectivityChanged(ConnectivityResult currentResult) {
    GetIt.instance.get<AppManager>().setConnectionState(currentResult);
    bool establishedConnection = _previousResult == ConnectivityResult.none &&
            currentResult == ConnectivityResult.wifi ||
        currentResult == ConnectivityResult.mobile;

    bool lostConnection = _previousResult == ConnectivityResult.wifi ||
        _previousResult == ConnectivityResult.mobile &&
            currentResult == ConnectivityResult.none;

    if (establishedConnection) {
      _handleEstablishedConnection();
    } else if (lostConnection) {
      _handleLossOfConnection();
    }

    _previousResult = currentResult;
  }

  Future<bool> isConnected() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void _handleEstablishedConnection() {
    Pages currentPage = GetIt.instance.get<AppManager>().getCurrentPage();
    switch (currentPage) {
      case Pages.LandingPage:
        _onConnectivityEstablishedCallbackLandingPage();
        break;
      case Pages.MainPage:
        _onConnectivityEstablishedCallbackMainPage();
        break;
      case Pages.FavouritesPage:
        _onConnectivityEstablishedCallbackFavouriteMovies();
        break;
    }
  }

  void _handleLossOfConnection() {
    Pages currentPage = GetIt.instance.get<AppManager>().getCurrentPage();
    print('lost connection on page: $currentPage');
    switch (currentPage) {
      case Pages.LandingPage:
        _onConnectivityLostCallbackLandingPage();
        break;
      case Pages.MainPage:
        _onConnectivityLostCallbackMainPage();
        break;
      case Pages.FavouritesPage:
        _onConnectivityLostCallbackFavouriteMovies();
        break;
    }
  }

  void dispose() {
    _subscription.cancel();
  }
}
