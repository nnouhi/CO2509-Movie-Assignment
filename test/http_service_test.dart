import 'dart:convert';

import 'package:co2509_assignment/models/app_config.dart';
import 'package:co2509_assignment/models/endpoints.dart';
import 'package:co2509_assignment/services/firebase_service.dart';
import 'package:co2509_assignment/services/http_service.dart';
import 'package:co2509_assignment/services/sharedpreferences_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'http_service_test.mocks.dart';

@GenerateMocks(
    [FirebaseService, SharedPreferencesService, Dio, Response, AppConfig])
void main() {
  group(
    'HTTP Service Testing',
    () {
      late HTTPService httpService;
      late MockFirebaseService firebaseServiceMock;
      late MockSharedPreferencesService sharedPreferencesServiceMock;
      late MockDio dioMock;
      late MockAppConfig appConfigMock;
      late String apiKey;

      setUpAll(
        () async {
          WidgetsFlutterBinding
              .ensureInitialized(); // Initialize the ServicesBinding
          firebaseServiceMock = MockFirebaseService();
          sharedPreferencesServiceMock = MockSharedPreferencesService();
          dioMock = MockDio();
          appConfigMock = MockAppConfig();

          GetIt.instance
              .registerSingleton<FirebaseService>(firebaseServiceMock);
          GetIt.instance.registerSingleton<SharedPreferencesService>(
              sharedPreferencesServiceMock);
          GetIt.instance.registerSingleton<Dio>(dioMock);
          GetIt.instance.registerSingleton<AppConfig>(appConfigMock);

          // Decode json file
          final dynamic configFile =
              await rootBundle.loadString('assets/config/main.json');
          final dynamic configData = jsonDecode(configFile);
          apiKey = configData['API_KEY'];
        },
      );

      test(
        'should make a successful GET request with the correct parameters',
        () async {
          // Arrange
          String apiUrl = 'https://api.themoviedb.org/3';
          when(appConfigMock.apiKey).thenReturn(apiKey);
          when(appConfigMock.baseApiUrl).thenReturn(apiUrl);

          httpService = HTTPService();

          final endpoint = Endpoints.latestMoviesEndpoint;
          final language = 'English';
          final additionalParams = {
            'page': 1,
          };
          final url = '$apiUrl$endpoint';

          final mockResponse = MockResponse();
          when(mockResponse.statusCode).thenReturn(200);
          when(firebaseServiceMock.getOnlineAppLanguage())
              .thenAnswer((_) async => language);
          when(dioMock.get(
            url,
            queryParameters: additionalParams,
          )).thenAnswer((_) async => mockResponse);

          // Act
          Response response =
              await httpService.getRequest(endpoint, additionalParams);

          // Assert
          expect(response.statusCode, equals(mockResponse.statusCode));
        },
      );

      test(
        'should throw DioError when GET request fails',
        () async {
          // Arrange
          String apiUrl = 'https://invalid/url/3';
          when(appConfigMock.apiKey).thenReturn(apiKey);
          when(appConfigMock.baseApiUrl).thenReturn(apiUrl);

          httpService = HTTPService();

          final endpoint = Endpoints.latestMoviesEndpoint;
          final language = 'English';
          final additionalParams = {
            'page': 1,
          };
          final url = '$apiUrl$endpoint';

          final dioError = DioError(requestOptions: RequestOptions(path: url));
          when(firebaseServiceMock.getOnlineAppLanguage())
              .thenAnswer((_) async => language);
          when(
            dioMock.get(
              url,
              queryParameters: additionalParams,
            ),
          ).thenThrow(dioError);

          // Act
          try {
            await httpService.getRequest(endpoint, additionalParams);
            fail('Expected DioError');
          } catch (e) {
            expect(e, isA<DioError>());
            expect((e as DioError).response, isNull);
          }
        },
      );

      test(
        'should make a successful POST request with the correct parameters',
        () async {
          // Arrange
          String apiUrl = 'https://api.themoviedb.org/3';
          when(appConfigMock.apiKey).thenReturn(apiKey);
          when(appConfigMock.baseApiUrl).thenReturn(apiUrl);

          final endpoint = '/movie/315162/rating';
          final body = {
            'value': 8.5,
          };
          final sessionId = '57782b86d2050f1a1a00d7dd21f5bfc7';

          final mockResponse = MockResponse();
          when(mockResponse.statusCode).thenReturn(201);
          when(GetIt.instance
                  .get<SharedPreferencesService>()
                  .getString('guestSessionId'))
              .thenAnswer((_) async => sessionId);
          when(dioMock.post(
            '$apiUrl$endpoint',
            queryParameters: {
              'api_key': apiKey,
              'guest_session_id': sessionId,
            },
            options: anyNamed('options'),
            data: body,
          )).thenAnswer((_) async => mockResponse);

          httpService = HTTPService();

          // Act
          final response = await httpService.postRequest(endpoint, body);

          // Assert
          expect(response.statusCode, equals(mockResponse.statusCode));
        },
      );

      test(
        'should throw DioError when Post request fails',
        () async {
          // Arrange
          String apiUrl = 'https://api.themoviedb.org/3';
          when(appConfigMock.apiKey).thenReturn(apiKey);
          when(appConfigMock.baseApiUrl).thenReturn(apiUrl);

          final endpoint = '/movie/315162/rating';
          final body = {
            'value': 8.5,
          };
          final sessionId = 'invalid_session_id';

          final mockResponse = MockResponse();

          when(GetIt.instance
                  .get<SharedPreferencesService>()
                  .getString('guestSessionId'))
              .thenAnswer((_) async => sessionId);

          // use when for DioError to simulate a failure
          when(dioMock.post(
            '$apiUrl$endpoint',
            queryParameters: {
              'api_key': apiKey,
              'guest_session_id': sessionId,
            },
            options: anyNamed('options'),
            data: body,
          ));

          httpService = HTTPService();

          // Act & Assert
          try {
            await httpService.postRequest(endpoint, body);
            fail('Expected DioError');
          } catch (e) {
            expect(e, isA<DioError>());
          }
        },
      );
    },
  );
}
