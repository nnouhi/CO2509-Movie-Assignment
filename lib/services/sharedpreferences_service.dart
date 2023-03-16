// Packages
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _sharedPreferences;

  SharedPreferencesService(this._sharedPreferences);

  // Wrapper methods
  Future<bool> setString(String key, String value) async {
    return _sharedPreferences.setString(key, value);
  }

  Future<String> getString(String key) async {
    return _sharedPreferences.getString(key) ?? '';
  }

  Future<bool> setBool(String key, bool value) async {
    return _sharedPreferences.setBool(key, value);
  }

  Future<bool> getBool(String key) async {
    return _sharedPreferences.getBool(key) ?? true;
  }
}
