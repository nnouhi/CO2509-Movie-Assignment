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

  Future<Response> getRequest(
      String endpoint, Map<String, dynamic>? optionalQueryParams) async {
    try {
      String url = '$_baseUrl$endpoint';
      Map<String, dynamic> requiredQueryParams = {
        'api_key': _apiKey,
        'language': 'en-US',
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
}
