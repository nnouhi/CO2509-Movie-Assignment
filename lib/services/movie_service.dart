// Packages
import 'package:get_it/get_it.dart';
// Services
import '../services/http_service.dart';

class MovieService {
  final GetIt getIt = GetIt.instance;
  late final HTTPService httpService;

  MovieService() {
    httpService = getIt.get<HTTPService>();
  }
}
