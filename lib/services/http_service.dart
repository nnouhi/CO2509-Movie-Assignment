// Models
import 'package:co2509_assignment/models/endpoints.dart';

import '../models/app_config.dart';
// Services
import '../services/firebase_service.dart';
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
      String? endpoint, Map<String, dynamic> body) async {
    try {
      String? guestSessionId =
          await _getGuestSessionId(Endpoints.newGuestTokenEndpoint);

      final String url = '$_baseUrl$endpoint';

      Map<String, dynamic> requiredQueryParams = {
        'api_key': _apiKey,
        'guest_session_id': guestSessionId,
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

      if (response.statusCode == 201) {
        return response;
      } else {
        throw Exception(response.statusCode);
      }
    } on DioError catch (e) {
      throw e;
    }
  }

  Future<Response> getRequest(
      String endpoint, Map<String, dynamic>? optionalQueryParams) async {
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
      // ISSUE Doesnt take endpoint into account
      Response response = await dio.get(
        url,
        queryParameters: requiredQueryParams,
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(response.statusCode);
      }
    } on DioError catch (e) {
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  Future<String> _getGuestSessionId(String endpoint) async {
    try {
      String url = '$_baseUrl$endpoint';
      Map<String, dynamic> requiredQueryParams = {
        'api_key': _apiKey,
      };
      Response response = await dio.get(
        url,
        queryParameters: requiredQueryParams,
      );
      if (response.statusCode == 200) {
        return response.data['guest_session_id'];
      } else {
        throw Exception(response.statusCode);
      }
    } on DioError catch (e) {
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  String _getCodeISO(String appLanguage) {
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
