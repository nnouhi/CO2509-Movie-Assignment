// Models
import '../models/endpoints.dart';
import '../models/app_config.dart';
// Services
import '../services/firebase_service.dart';
import '../services/sharedpreferences_service.dart';
// Packages
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

class HTTPService {
  final Dio dio = Dio();
  final GetIt getIt = GetIt.instance;

  late String _baseUrl;
  late String _apiKey;
  late FirebaseService _firebaseService;

  HTTPService() {
    AppConfig config = getIt<AppConfig>();
    _firebaseService = getIt<FirebaseService>();
    _baseUrl = config.baseApiUrl;
    _apiKey = config.apiKey;
  }

  Future<Response> postRequest(
    String? endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      // Try and get the guest session id from shared preferences
      String? sessionId = await getIt
          .get<SharedPreferencesService>()
          .getString('guestSessionId');

      print(sessionId);

      // User didn't rate any movies yet, generate him a session id
      if (sessionId.isEmpty) {
        Response sessionReponse = await _getGuestSessionId(
          Endpoints.newGuestTokenEndpoint,
        );

        sessionId = sessionReponse.data['guest_session_id'];
        getIt
            .get<SharedPreferencesService>()
            .setString('guestSessionId', sessionId!);
      }

      final String url = '$_baseUrl$endpoint';
      Map<String, dynamic> requiredQueryParams = {
        'api_key': _apiKey,
        'guest_session_id': sessionId,
      };
      Map<String, String> headers = {
        "Content-Type": "application/json;charset=utf-8"
      };

      Response response = await dio.post(
        url,
        queryParameters: requiredQueryParams,
        options: Options(headers: headers),
        data: body,
      );

      return response;
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<Response> getRequest(
    String endpoint,
    Map<String, dynamic>? optionalQueryParams,
  ) async {
    Response response;
    try {
      String? fetchLanguage = await _firebaseService.getOnlineAppLanguage();
      String url = '$_baseUrl$endpoint';
      Map<String, dynamic> requiredQueryParams = {
        'api_key': _apiKey,
        'language': _getCodeISO(fetchLanguage),
      };

      // Add any additional query params
      if (optionalQueryParams != null) {
        requiredQueryParams.addAll(optionalQueryParams);
      }

      // Perform the request
      response = await dio.get(
        url,
        queryParameters: requiredQueryParams,
      );

      return response;
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<Response> _getGuestSessionId(
    String endpoint,
  ) async {
    try {
      String url = '$_baseUrl$endpoint';
      Map<String, dynamic> requiredQueryParams = {
        'api_key': _apiKey,
      };
      Response response = await dio.get(
        url,
        queryParameters: requiredQueryParams,
      );

      return response;
    } on DioError catch (e) {
      rethrow;
    }
  }

  String _getCodeISO(
    String appLanguage,
  ) {
    switch (appLanguage) {
      case 'English':
        return 'en-US';
      case 'Ελληνικά':
        return 'el-GR';
      case 'Русский':
        return 'ru-RU';
      case 'Türkçe':
        return 'tr-TR';
      case 'Français':
        return 'fr-FR';
    }

    return 'English';
  }
}
