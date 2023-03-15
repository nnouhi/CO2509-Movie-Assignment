class UpdateManager {
  bool _favouriteMoviesUpdater = false;
  bool _mainPageUpdater = false;

  UpdateManager();
  // Favourite Movies Page
  bool getFavouriteMoviesDirtyState() => _favouriteMoviesUpdater;
  void setFavouriteMoviesAsDirty(bool isDirty) =>
      _favouriteMoviesUpdater = isDirty;

  // Main Page
  bool getMainPageDirtyState() => _mainPageUpdater;
  void setMainPageAsDirty(bool isDirty) => _mainPageUpdater = isDirty;
}
