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
  Function get onConnectivityEstablishedCallbackFavouriteMovies =>
      _onConnectivityEstablishedCallbackFavouriteMovies;

  late Function _onConnectivityEstablishedCallbackLandingPage;
  Function get onConnectivityEstablishedCallbackLandingPage =>
      _onConnectivityEstablishedCallbackLandingPage;

  late Function _onConnectivityEstablishedCallbackMainPage;
  Function get onConnectivityEstablishedCallbackMainPage =>
      _onConnectivityEstablishedCallbackMainPage;

  late Function _onConnectivityLostCallbackFavouriteMovies;
  Function get onConnectivityLostCallbackFavouriteMovies =>
      _onConnectivityLostCallbackFavouriteMovies;

  late Function _onConnectivityLostCallbackLandingPage;
  Function get onConnectivityLostCallbackLandingPage =>
      _onConnectivityLostCallbackLandingPage;

  late Function _onConnectivityLostCallbackMainPage;
  Function get onConnectivityLostCallbackMainPage =>
      _onConnectivityLostCallbackMainPage;

  ConnectivityResult _previousResult = ConnectivityResult.none;
  bool isInitialized = false;

  ConnectivityService(this._connectivity);

  void subscribe() {
    _subscription =
        _connectivity.onConnectivityChanged.listen(onConnectivityChanged);
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

  void onConnectivityChanged(ConnectivityResult currentResult) {
    GetIt.instance.get<AppManager>().setConnectionState(currentResult);
    bool establishedConnection = _previousResult == ConnectivityResult.none &&
            currentResult == ConnectivityResult.wifi ||
        currentResult == ConnectivityResult.mobile;

    bool lostConnection = _previousResult == ConnectivityResult.wifi ||
        _previousResult == ConnectivityResult.mobile &&
            currentResult == ConnectivityResult.none;

    if (establishedConnection) {
      handleEstablishedConnection();
    } else if (lostConnection) {
      handleLossOfConnection();
    }

    _previousResult = currentResult;
  }

  Future<bool> isConnected() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void handleEstablishedConnection() {
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

  void handleLossOfConnection() {
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
