import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app_flutter/data/model/user_session.dart';
import 'package:story_app_flutter/data/preferences/auth_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthPreferences Tests', () {
    test('Menyimpan data sesi dan token di preferences dengan benar', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final authPreferences = AuthPreferences(prefs);

      const session = UserSession(
        userId: 'user-123',
        name: 'Dicoding Student',
        token: 'sample_jwt_token_xyz',
      );

      final saveResult = await authPreferences.saveSession(session);

      expect(saveResult, isTrue);
      expect(authPreferences.isLoggedIn(), isTrue);
      expect(authPreferences.getToken(), equals('sample_jwt_token_xyz'));

      final retrievedSession = authPreferences.getSession();
      expect(retrievedSession, isNotNull);
      expect(retrievedSession?.userId, equals('user-123'));
      expect(retrievedSession?.name, equals('Dicoding Student'));
      expect(retrievedSession?.token, equals('sample_jwt_token_xyz'));
    });

    test('Proses logout berhasil menghapus token dan sesi dari preferences',
        () async {
      SharedPreferences.setMockInitialValues({
        'auth_token': 'sample_jwt_token_xyz',
        'user_id': 'user-123',
        'user_name': 'Dicoding Student',
        'is_logged_in': true,
      });

      final prefs = await SharedPreferences.getInstance();
      final authPreferences = AuthPreferences(prefs);

      expect(authPreferences.isLoggedIn(), isTrue);
      expect(authPreferences.getToken(), equals('sample_jwt_token_xyz'));

      final clearResult = await authPreferences.clearSession();

      expect(clearResult, isTrue);
      expect(authPreferences.isLoggedIn(), isFalse);
      expect(authPreferences.getToken(), isNull);
      expect(authPreferences.getSession(), isNull);
    });
  });
}

