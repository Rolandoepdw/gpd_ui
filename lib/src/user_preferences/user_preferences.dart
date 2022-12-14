import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  SharedPreferences? _userPreferences;

  //----------------------------- Pattern Singleton -----------------------------

  static final UserPreferences _instance = UserPreferences._();

  UserPreferences._();

  factory UserPreferences() {
    return _instance;
  }

  //------------------------- Initializing preferences -------------------------

  initUserPreferences() async {
    _userPreferences = await SharedPreferences.getInstance();
  }

  //----------------------------- Set and get Data -----------------------------

  set userData(userData) {
    _userPreferences?.setString('userData', userData);
  }

  get userData => _userPreferences?.get('userData') ?? 'userPreferences error';

  removeUserPreferencesData() async =>
      await _userPreferences?.remove('userData');
}
