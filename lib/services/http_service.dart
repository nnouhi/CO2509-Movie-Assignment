import '../models/app_config.dart';

// Packages
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

class HTTPService {
  final Dio dio = Dio();
  final GetIt getIt = GetIt.instance;

  late String _baseUrl;
  late String _apiKey;

  HTTPService() {
    AppConfig config = getIt<AppConfig>();
    _baseUrl = config.baseApiUrl;
    _apiKey = config.apiKey;
  }

  Future<Response> getRequest(String endpoint, int page) async {
    try {
      Response response = await dio.get('$_baseUrl$endpoint', queryParameters: {
        'api_key': _apiKey,
        'language': 'en-US',
        'page': page,
      });
      return response;
    } on DioError catch (e) {
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }
}
