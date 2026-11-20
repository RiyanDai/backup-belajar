import 'package:flutter/widgets.dart';
import '../common/result_state.dart';
import '../data/api/api_service.dart';
import '../data/model/user_session.dart';
import '../data/preferences/auth_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;
  final AuthPreferences _authPreferences;

  ResultState _state = ResultState.initial;
  bool _isLoading = false;
  String? _errorMessage;
  UserSession? _userSession;
  bool _isLoggedIn = false;

  AuthProvider(
    this._apiService,
    this._authPreferences,
  ) {
    _initSession();
  }

  ResultState get state => _state;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserSession? get userSession => _userSession;
  bool get isLoggedIn => _isLoggedIn;

  void _initSession() {
    _isLoggedIn = _authPreferences.isLoggedIn();
    _userSession = _authPreferences.getSession();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _state = ResultState.loading;
    notifyListeners();

    try {
      final response = await _apiService.login(
        email: email,
        password: password,
      );

      final loginResult = response.loginResult;
      if (loginResult != null) {
        final session = UserSession(
          userId: loginResult.userId,
          name: loginResult.name,
          token: loginResult.token,
        );
        await _authPreferences.saveSession(session);
        _userSession = session;
        _isLoggedIn = true;
        _state = ResultState.hasData;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid login response from server.';
        _state = ResultState.error;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = ResultState.error;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _state = ResultState.loading;
    notifyListeners();

    try {
      final response = await _apiService.register(
        name: name,
        email: email,
        password: password,
      );

      _isLoading = false;
      if (!response.error) {
        _state = ResultState.hasData;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        _state = ResultState.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = ResultState.error;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authPreferences.clearSession();
    _userSession = null;
    _isLoggedIn = false;
    _state = ResultState.initial;
    _errorMessage = null;
    notifyListeners();
  }
}
