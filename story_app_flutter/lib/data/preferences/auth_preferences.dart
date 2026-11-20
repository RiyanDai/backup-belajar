import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_session.dart';

class AuthPreferences {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _nameKey = 'user_name';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _localeKey = 'app_locale';

  final SharedPreferences _preferences;

  AuthPreferences(this._preferences);

  static Future<AuthPreferences> init() async {
    final prefs = await SharedPreferences.getInstance();
    return AuthPreferences(prefs);
  }

  Future<bool> saveSession(UserSession session) async {
    await _preferences.setString(_tokenKey, session.token);
    await _preferences.setString(_userIdKey, session.userId);
    await _preferences.setString(_nameKey, session.name);
    return await _preferences.setBool(_isLoggedInKey, true);
  }

  UserSession? getSession() {
    final token = _preferences.getString(_tokenKey);
    final userId = _preferences.getString(_userIdKey);
    final name = _preferences.getString(_nameKey);

    if (token != null && userId != null && name != null) {
      return UserSession(
        userId: userId,
        name: name,
        token: token,
      );
    }
    return null;
  }

  String? getToken() {
    return _preferences.getString(_tokenKey);
  }

  bool isLoggedIn() {
    return _preferences.getBool(_isLoggedInKey) ?? false;
  }

  Future<bool> clearSession() async {
    await _preferences.remove(_tokenKey);
    await _preferences.remove(_userIdKey);
    await _preferences.remove(_nameKey);
    return await _preferences.setBool(_isLoggedInKey, false);
  }

  Future<bool> setLocaleCode(String languageCode) async {
    return await _preferences.setString(_localeKey, languageCode);
  }

  String? getLocaleCode() {
    return _preferences.getString(_localeKey);
  }
}

