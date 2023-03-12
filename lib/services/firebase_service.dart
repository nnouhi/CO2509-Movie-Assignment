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

  void setOnlineAppTheme(bool isDarkTheme, Function appThemeCallback) {
    _databaseReference
        .child('app-preferences')
        .child('IsDarkTheme')
        .set(isDarkTheme)
        .then(
          (value) => appThemeCallback(),
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
