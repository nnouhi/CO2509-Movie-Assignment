import 'dart:async';
// Packages
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  late DatabaseReference _databaseReference;
  late StreamSubscription _streamSubscription;

  FirebaseService() {
    _databaseReference = FirebaseDatabase.instance.ref();
    // _streamSubscription = _databaseReference.onValue.listen((event) {
    //   print(event.snapshot.value);
    // });
  }

  // App Language
  void setOnlineAppLanguage(String language, Function appThemeCallback) {
    _databaseReference
        .child('app-preferences')
        .child('Language')
        .set(language)
        .then(
          (value) => appThemeCallback(),
        )
        .catchError(
          (error) => print('Error: $error'),
        );
  }

  Future<String> getOnlineAppLanguage() async {
    try {
      DataSnapshot snapshot = await _databaseReference
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
        .child('app-preferences')
        .child('IsDarkTheme')
        .set(isDarkTheme)
        .then(
          (_) => appThemeCallback(),
        )
        .catchError(
          (error) => print('Error: $error'),
        );
  }

  Future<bool> getOnlineAppTheme() async {
    try {
      DataSnapshot snapshot = await _databaseReference
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
