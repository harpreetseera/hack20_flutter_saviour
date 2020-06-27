import 'package:shared_preferences/shared_preferences.dart';

class Saviour {
  static SharedPreferences prefs;
  
  static const String PREF_LOGGED_IN = "prefLoggedIn";
  static const String PREF_UID = "prefUId";
  static const String PREF_EMAIL = "prefEmail";
  
}
