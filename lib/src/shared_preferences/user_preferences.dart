import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {

  static final UserPreferences _instance = new UserPreferences._internal();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  SharedPreferences _prefs;

  initPreferences() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // String _token;
  // String _lastScreen;


  get token {
    return _prefs.getString('token') ?? '';
  }

  set token(String value) {
    _prefs.setString('token', value);
  }

  get lastScreen {
    return _prefs.getString('lastScreen') ?? 'login';
  }

  set lastScreen(String value) {
    _prefs.setString('lastScreen', value);
  }

}