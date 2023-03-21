import 'package:co2509_assignment/controllers/app_manager.dart';
import 'package:co2509_assignment/models/pages.dart';
import 'package:co2509_assignment/services/connectivity_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'connectivity_service_test.mocks.dart';

abstract class MockCallback {
  void callback();
}

class MockedCallback extends Mock implements MockCallback {}

@GenerateMocks([ConnectivityService, Connectivity, AppManager])
void main() {
  group(
    'Connectivity Service Testing',
    () {
      late MockConnectivity connectivityMock;
      late ConnectivityService connectivityService;
      late MockAppManager appManagerMock;

      setUpAll(
        () {
          connectivityMock = MockConnectivity();
          connectivityService = ConnectivityService(connectivityMock);
          appManagerMock = MockAppManager();
          GetIt.instance.registerSingleton<AppManager>(appManagerMock);
        },
      );

      test(
        'Subscribe should call onConnectivityChanged',
        () {
          // Arrange
          when(connectivityMock.onConnectivityChanged).thenAnswer(
            (_) => Stream.empty(),
          );

          // Act
          connectivityService.subscribe();

          // Assert
          verify(
            connectivityMock.onConnectivityChanged.listen(
              connectivityService.onConnectivityChanged,
            ),
          ).called(1);
        },
      );

      test(
        'setOnConnectivityEstablishedCallback should set the correct callback',
        () {
          // Arrange
          final mockCallback = () => print('connectivity established callback');

          when(
            appManagerMock.getCurrentPage(),
          ).thenReturn(Pages.LandingPage);

          // Act
          connectivityService
              .setOnConnectivityEstablishedCallback(mockCallback);

          // Assert
          expect(
            connectivityService.onConnectivityEstablishedCallbackLandingPage,
            mockCallback,
          );
        },
      );

      test(
        'setOnConnectivityLostCallback should set the correct callback',
        () {
          // Arrange
          final mockCallback = () => print('connectivity lost callback');

          when(
            appManagerMock.getCurrentPage(),
          ).thenReturn(Pages.LandingPage);

          // Act
          connectivityService.setOnConnectivityLostCallback(mockCallback);

          // Assert
          expect(
            connectivityService.onConnectivityLostCallbackLandingPage,
            mockCallback,
          );
        },
      );

      test(
        'handleEstablishedConnection should call the correct callback based on the current page',
        () {
          // Arrange
          final mockCallback = MockedCallback();
          when(
            appManagerMock.getCurrentPage(),
          ).thenReturn(Pages.LandingPage);

          connectivityService
              .setOnConnectivityEstablishedCallback(mockCallback.callback);

          // Act
          connectivityService.handleEstablishedConnection();

          // Assert
          verify(mockCallback.callback()).called(1);
        },
      );

      test(
        'handleLossOfConnection should call the correct callback based on the current page',
        () {
          // Arrange
          final mockCallback = MockedCallback();
          when(
            appManagerMock.getCurrentPage(),
          ).thenReturn(Pages.LandingPage);

          connectivityService
              .setOnConnectivityLostCallback(mockCallback.callback);

          // Act
          connectivityService.handleLossOfConnection();

          // Assert
          verify(mockCallback.callback()).called(1);
        },
      );
    },
  );
}
