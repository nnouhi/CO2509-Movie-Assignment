import '../models/app_config.dart';

// Packages
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

class HTTPService {
  final dio = Dio();
  final getIt = GetIt.instance;

  late String _baseUrl;
  late String _apiKey;

  HTTPService() {
    AppConfig config = getIt<AppConfig>();
    _baseUrl = config.baseApiUrl;
    _apiKey = config.apiKey;
  }

  Future<Response> getRequest(String endpoint) async {
    try {
      Response response = await dio.get(
        _baseUrl + endpoint,
        queryParameters: {
          'api_key': _apiKey,
          'language': 'en-US',
        },
      );
      return response;
    } on DioError catch (e) {
      throw e;
    }
  }
}
