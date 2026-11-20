import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app_flutter/common/result_state.dart';
import 'package:story_app_flutter/data/api/api_service.dart';
import 'package:story_app_flutter/data/model/user_session.dart';
import 'package:story_app_flutter/data/preferences/auth_preferences.dart';
import 'package:story_app_flutter/provider/auth_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthPreferences authPreferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    authPreferences = AuthPreferences(prefs);
  });

  group('AuthProvider Tests', () {
    test('Proses registrasi berhasil dengan benar', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.endsWith('/register') &&
            request.method == 'POST') {
          return http.Response(
            jsonEncode({
              'error': false,
              'message': 'User Created',
            }),
            201,
          );
        }
        return http.Response('Not Found', 404);
      });

      final apiService = ApiService(client: mockClient);
      final authProvider = AuthProvider(apiService, authPreferences);

      final result = await authProvider.register(
        name: 'Dicoding User',
        email: 'user@dicoding.com',
        password: 'password123',
      );

      expect(result, isTrue);
      expect(authProvider.state, equals(ResultState.hasData));
      expect(authProvider.errorMessage, isNull);
    });

    test('Proses login berhasil dengan benar dan menyimpan sesi', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.endsWith('/login') && request.method == 'POST') {
          return http.Response(
            jsonEncode({
              'error': false,
              'message': 'success',
              'loginResult': {
                'userId': 'user-abc-123',
                'name': 'Dicoding User',
                'token': 'jwt_mock_token_12345',
              },
            }),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      final apiService = ApiService(client: mockClient);
      final authProvider = AuthProvider(apiService, authPreferences);

      final result = await authProvider.login(
        'user@dicoding.com',
        'password123',
      );

      expect(result, isTrue);
      expect(authProvider.isLoggedIn, isTrue);
      expect(authProvider.state, equals(ResultState.hasData));
      expect(authProvider.userSession?.token, equals('jwt_mock_token_12345'));
      expect(authPreferences.getToken(), equals('jwt_mock_token_12345'));
      expect(authPreferences.isLoggedIn(), isTrue);
    });

    test('Proses logout berhasil dengan benar', () async {
      final mockClient = MockClient((_) async => http.Response('{}', 200));
      final apiService = ApiService(client: mockClient);

      await authPreferences.saveSession(
        const UserSession(
          userId: 'user-abc-123',
          name: 'Dicoding User',
          token: 'jwt_mock_token_12345',
        ),
      );

      final authProvider = AuthProvider(apiService, authPreferences);
      expect(authProvider.isLoggedIn, isTrue);

      await authProvider.logout();

      expect(authProvider.isLoggedIn, isFalse);
      expect(authProvider.userSession, isNull);
      expect(authProvider.state, equals(ResultState.initial));
      expect(authPreferences.isLoggedIn(), isFalse);
      expect(authPreferences.getToken(), isNull);
    });
  });
}
