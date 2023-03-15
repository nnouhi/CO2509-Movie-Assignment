// Packages
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _sharedPreferences;

  SharedPreferencesService(this._sharedPreferences);

  Future<bool> setString(String key, String value) async {
    return _sharedPreferences.setString(key, value);
  }

  Future<String> getString(String key) async {
    return _sharedPreferences.getString(key) ?? '';
  }
}
