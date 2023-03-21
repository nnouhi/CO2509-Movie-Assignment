import 'package:co2509_assignment/models/movie.dart';
import 'package:co2509_assignment/pages/main_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MainPage mainPage;
  late List<Movie> moviesToSort;

  setUpAll(
    () {
      // Arrange
      mainPage = MainPage(
        isDarkTheme: false,
      );

      moviesToSort = [
        Movie(title: 'b', voteAverage: 8.2, releaseDate: '2021-01-02'),
        Movie(title: 'a', voteAverage: 9.2, releaseDate: '2021-01-01'),
        Movie(title: 'c', voteAverage: 7.2, releaseDate: '2021-01-03')
      ];

      // Act

      // Assert
    },
  );
  group(
    'Testing the sort methods of main page,',
    () {
      test(
        'Testing if movie titles are getting sorted in an ascending order',
        () {
          // Arrange

          // Act
          mainPage.sortMoviesByTitle(moviesToSort, true);

          //Assert
          expect(moviesToSort[0].title, 'a');
          expect(moviesToSort[1].title, 'b');
        },
      );

      test(
        'Testing if movie titles are getting sorted in a descending order',
        () {
          // Arrange

          // Act
          mainPage.sortMoviesByTitle(moviesToSort, false);

          //Assert
          expect(moviesToSort[0].title, 'c');
          expect(moviesToSort[1].title, 'b');
        },
      );

      test(
        'Testing if movie release dates are getting sorted in an ascending order',
        () {
          // Arrange

          // Act
          mainPage.sortMoviesByDate(moviesToSort, true);

          //Assert
          expect(moviesToSort[0].releaseDate, '2021-01-01');
          expect(moviesToSort[1].releaseDate, '2021-01-02');
        },
      );

      test(
        'Testing if movie release dates are getting sorted in a descending order',
        () {
          // Arrange

          // Act
          mainPage.sortMoviesByDate(moviesToSort, false);

          //Assert
          expect(moviesToSort[0].releaseDate, '2021-01-03');
          expect(moviesToSort[1].releaseDate, '2021-01-02');
        },
      );
    },
  );
}
