import 'package:shared_preferences/shared_preferences.dart';

class Preferences{
   static late SharedPreferences _prefs;

   static String _token = '';

   static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String getToken() {
    return _prefs.getString('idToken') ?? _token;
  }

  static setToken ( String token ) {
    _token = token;
    _prefs.setString('idToken', token );
  }

  static clearPrefs(){
    _prefs.clear();
  }
}