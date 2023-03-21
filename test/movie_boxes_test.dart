import 'package:co2509_assignment/controllers/app_manager.dart';
import 'package:co2509_assignment/models/app_config.dart';
import 'package:co2509_assignment/models/movie.dart';
import 'package:co2509_assignment/services/database_service.dart';
import 'package:co2509_assignment/widgets/movie_box_remove_from_favourites.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_boxes_test.mocks.dart';

@GenerateMocks([AppManager, DatabaseService, AppConfig])
void main() {
  group(
    'MovieBoxRemoveFromFavourites Widget Testing',
    () {
      late MockAppManager mockAppManager;
      late MockDatabaseService mockDatabaseService;
      late Movie movie;
      late MockAppConfig mockAppConfig;
      late Function(void) favouriteMovieCallback;

      setUpAll(
        () {
          mockAppManager = MockAppManager();
          mockDatabaseService = MockDatabaseService();
          mockAppConfig = MockAppConfig();
          movie = Movie(
            posterPath: '/kuf6dutpsT0vSVehic3EZIqkOBt.jpg',
            title: 'Test Movie',
            voteAverage: 7.5,
            originalLanguage: 'en',
            adult: false,
            releaseDate: '2022-01-01',
            overview: 'This is a test movie',
            id: 315162,
          );
          favouriteMovieCallback = (void arg) => print('Callback called');

          GetIt.instance.registerSingleton<AppManager>(mockAppManager);
          GetIt.instance
              .registerSingleton<DatabaseService>(mockDatabaseService);
          GetIt.instance.registerSingleton<AppConfig>(mockAppConfig);
        },
      );

      testWidgets(
        'MovieBoxRemoveFromFavourites widget should display movie details',
        (WidgetTester tester) async {
          // Arrange
          when(GetIt.instance.get<AppManager>().isConnected())
              .thenReturn(false);

          final widget = MovieBoxRemoveFromFavourites(
            width: 500,
            height: 400,
            movie: movie,
            favouriteMovieCallback: favouriteMovieCallback,
          );

          // Act
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: widget,
              ),
            ),
          );

          // Assert
          expect(find.text(movie.title.toString()), findsOneWidget);
          expect(find.text(movie.voteAverage.toString()), findsOneWidget);
          expect(find.text(movie.overview!), findsOneWidget);
          expect(
              find.text(
                '${movie.originalLanguage!.toUpperCase()} | R: ${movie.adult! ? '18+' : '13+'} | ${movie.releaseDate!}',
              ),
              findsOneWidget);
          // Find the ElevatedButton widget and check that it exists
          final removeButton = find.byType(ElevatedButton);
          expect(removeButton, findsOneWidget);
        },
      );

      testWidgets(
        'MovieBoxRemoveFromFavourites widget should display a dialog when remove button is pressed',
        (WidgetTester tester) async {
          // Arrange
          when(GetIt.instance.get<AppManager>().isConnected())
              .thenReturn(false);

          final widget = MovieBoxRemoveFromFavourites(
            width: 500,
            height: 400,
            movie: movie,
            favouriteMovieCallback: favouriteMovieCallback,
          );

          // Act
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: widget,
              ),
            ),
          );

          // Assert
          // Find the ElevatedButton widget and check that it exists
          final removeButton = find.byType(ElevatedButton);
          expect(removeButton, findsOneWidget);

          // Tap the remove from favourites button
          await tester.tap(removeButton);
          await tester.pumpAndSettle();

          // Verify that the dialog is showing
          expect(find.byType(AlertDialog), findsOneWidget);
          expect(find.text('Are you sure?'), findsOneWidget);
          expect(
              find.text(
                  'Would you like to remove ${movie.title} from favourites?'),
              findsOneWidget);
          expect(find.widgetWithText(TextButton, 'Cancel'), findsOneWidget);
          expect(find.widgetWithText(TextButton, 'Remove'), findsOneWidget);
        },
      );

      testWidgets(
        'When the remove dialg button is pressed, the movie should be removed from the database',
        (WidgetTester tester) async {
          // Arrange
          when(GetIt.instance.get<AppManager>().isConnected())
              .thenReturn(false);

          // Define the callback tracker
          bool callbackCalled = false;
          void _testCallback(_) {
            callbackCalled = true;
          }

          final widget = MovieBoxRemoveFromFavourites(
            width: 500,
            height: 400,
            movie: movie,
            favouriteMovieCallback: _testCallback,
          );

          // Act
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: widget,
              ),
            ),
          );

          // Assert
          // Find the ElevatedButton widget and check that it exists
          final removeButton = find.byType(ElevatedButton);
          expect(removeButton, findsOneWidget);

          // Tap the remove from favourites button
          await tester.tap(removeButton);
          await tester.pumpAndSettle();

          // Tap the remove button
          await tester.tap(find.widgetWithText(TextButton, 'Remove'));
          await tester.pumpAndSettle();

          verify(mockDatabaseService.removeMovieFromFavourites(movie))
              .called(1);
          // Verify that the favourite movie callback function was called
          expect(callbackCalled, true);
        },
      );

      testWidgets(
        'When the cancel dialog button is pressed, the dialog should be removed',
        (WidgetTester tester) async {
          // Arrange
          when(GetIt.instance.get<AppManager>().isConnected())
              .thenReturn(false);

          final widget = MovieBoxRemoveFromFavourites(
            width: 500,
            height: 400,
            movie: movie,
            favouriteMovieCallback: favouriteMovieCallback,
          );

          // Act
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: widget,
              ),
            ),
          );

          // Assert
          // Find the ElevatedButton widget and check that it exists
          final removeButton = find.byType(ElevatedButton);
          expect(removeButton, findsOneWidget);

          // Tap the remove from favourites button
          await tester.tap(removeButton);
          await tester.pumpAndSettle();

          // Verify that the dialog is showing
          expect(find.byType(AlertDialog), findsOneWidget);

          await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
          await tester.pumpAndSettle();

          // Verify that the dialog is not showing
          expect(find.byType(AlertDialog), findsNothing);
        },
      );
    },
  );
}
