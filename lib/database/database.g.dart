// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  FavouriteMoviesDao? _moviesDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Movie` (`id` INTEGER, `posterPath` TEXT, `adult` INTEGER, `overview` TEXT, `releaseDate` TEXT, `originalLanguage` TEXT, `title` TEXT, `voteAverage` REAL NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  FavouriteMoviesDao get moviesDao {
    return _moviesDaoInstance ??=
        _$FavouriteMoviesDao(database, changeListener);
  }
}

class _$FavouriteMoviesDao extends FavouriteMoviesDao {
  _$FavouriteMoviesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _movieInsertionAdapter = InsertionAdapter(
            database,
            'Movie',
            (Movie item) => <String, Object?>{
                  'id': item.id,
                  'posterPath': item.posterPath,
                  'adult': item.adult == null ? null : (item.adult! ? 1 : 0),
                  'overview': item.overview,
                  'releaseDate': item.releaseDate,
                  'originalLanguage': item.originalLanguage,
                  'title': item.title,
                  'voteAverage': item.voteAverage
                },
            changeListener),
        _movieDeletionAdapter = DeletionAdapter(
            database,
            'Movie',
            ['id'],
            (Movie item) => <String, Object?>{
                  'id': item.id,
                  'posterPath': item.posterPath,
                  'adult': item.adult == null ? null : (item.adult! ? 1 : 0),
                  'overview': item.overview,
                  'releaseDate': item.releaseDate,
                  'originalLanguage': item.originalLanguage,
                  'title': item.title,
                  'voteAverage': item.voteAverage
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Movie> _movieInsertionAdapter;

  final DeletionAdapter<Movie> _movieDeletionAdapter;

  @override
  Future<void> deleteAllFavouriteMovies() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Movie');
  }

  @override
  Future<List<Movie>> getFavouriteMovies() async {
    return _queryAdapter.queryList('SELECT * FROM Movie',
        mapper: (Map<String, Object?> row) => Movie(
            posterPath: row['posterPath'] as String?,
            adult: row['adult'] == null ? null : (row['adult'] as int) != 0,
            overview: row['overview'] as String?,
            releaseDate: row['releaseDate'] as String?,
            id: row['id'] as int?,
            originalLanguage: row['originalLanguage'] as String?,
            title: row['title'] as String?,
            voteAverage: row['voteAverage'] as double));
  }

  @override
  Stream<Movie?> findFavouriteById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Movie WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Movie(
            posterPath: row['posterPath'] as String?,
            adult: row['adult'] == null ? null : (row['adult'] as int) != 0,
            overview: row['overview'] as String?,
            releaseDate: row['releaseDate'] as String?,
            id: row['id'] as int?,
            originalLanguage: row['originalLanguage'] as String?,
            title: row['title'] as String?,
            voteAverage: row['voteAverage'] as double),
        arguments: [id],
        queryableName: 'Movie',
        isView: false);
  }

  @override
  Future<void> addFavouriteMovie(Movie movie) async {
    await _movieInsertionAdapter.insert(movie, OnConflictStrategy.abort);
  }

  @override
  Future<void> removeFavouriteMovie(Movie movie) async {
    await _movieDeletionAdapter.delete(movie);
  }
}
