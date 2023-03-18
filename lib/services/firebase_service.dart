import 'dart:async';
// Services
import '../services/sharedpreferences_service.dart';
// Packages
import 'package:get_it/get_it.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class FirebaseService {
  late DatabaseReference _databaseReference;
  late StreamSubscription _streamSubscription;
  late String _uuid;

  FirebaseService() {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    _databaseReference = FirebaseDatabase.instance.ref();
    _databaseReference.keepSynced(false);

    _checkIfUserExists();
  }

  void _checkIfUserExists() async {
    SharedPreferencesService sp =
        GetIt.instance.get<SharedPreferencesService>();

    String firebaseUID = await sp.getString('firebaseUID');

    // If user id doesn't exist, create a new one
    if (firebaseUID == '') {
      _uuid = Uuid().v4();
      bool success = await sp.setString('firebaseUID', _uuid);
      if (success) {
        _addNewUser();
      }
    } else {
      _uuid = firebaseUID;
    }
  }

  void _addNewUser() {
    _databaseReference.child('users').child(_uuid).set({
      'app-preferences': {
        'IsDarkTheme': false,
        'Language': 'English',
      },
    });
  }

  // App Language
  void setOnlineAppLanguage(String language, Function appThemeCallback) {
    _databaseReference
        .child('users')
        .child(_uuid)
        .child('app-preferences')
        .child('Language')
        .set(language);
    appThemeCallback();
  }

  Future<String> getOnlineAppLanguage() async {
    try {
      DataSnapshot snapshot = await _databaseReference
          .child('users')
          .child(_uuid)
          .child('app-preferences')
          .child('Language')
          .get();
      return snapshot.value as String;
    } catch (error) {
      print('Error: $error');
      return 'English'; // Or any other default value you want to return on error
    }
  }

  // App Theme
  void setOnlineAppTheme(bool isDarkTheme, Function appThemeCallback) {
    _databaseReference
        .child('users')
        .child(_uuid)
        .child('app-preferences')
        .child('IsDarkTheme')
        .set(isDarkTheme);

    appThemeCallback();
  }

  Future<bool> getOnlineAppTheme() async {
    try {
      DataSnapshot snapshot = await _databaseReference
          .child('users')
          .child(_uuid)
          .child('app-preferences')
          .child('IsDarkTheme')
          .get();
      return snapshot.value as bool;
    } catch (error) {
      print('Error: $error');
      return false; // Or any other default value you want to return on error
    }
  }
}
