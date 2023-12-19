import 'package:shared_preferences/shared_preferences.dart';

class AppSharePreference {
  static SharedPreferences? _prefs;

  static void init() {
    SharedPreferences.getInstance().then((value) {
      _prefs = value;
    });
  }

  static String getString(String key) => _prefs?.getString(key) ?? "";

  static void setString({String key = "", String value = ""}) {
    if (value.isEmpty || key.isEmpty) return;
    _prefs?.setString(key, value);
  }
}
