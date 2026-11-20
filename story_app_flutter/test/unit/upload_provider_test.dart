import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app_flutter/data/api/api_service.dart';
import 'package:story_app_flutter/data/preferences/auth_preferences.dart';
import 'package:story_app_flutter/provider/upload_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthPreferences authPreferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'auth_token': 'dummy_jwt_token',
      'is_logged_in': true,
    });
    final prefs = await SharedPreferences.getInstance();
    authPreferences = AuthPreferences(prefs);
  });

  group('Upload Story Tests', () {
    test('Proses menambah cerita baru berhasil sesuai kriteria multipart',
        () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.endsWith('/stories') && request.method == 'POST') {
          expect(request.headers['Authorization'], equals('Bearer dummy_jwt_token'));
          return http.Response(
            jsonEncode({
              'error': false,
              'message': 'success',
            }),
            201,
          );
        }
        return http.Response('Not Found', 404);
      });

      final apiService = ApiService(client: mockClient);
      final uploadProvider = UploadProvider(apiService, authPreferences);

      final dummyBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      final dummyFile = XFile.fromData(dummyBytes, name: 'story_sample.jpg');

      uploadProvider.setImageFile(dummyFile, dummyBytes);

      expect(uploadProvider.imageBytes, isNotNull);
      expect(uploadProvider.imageFile, isNotNull);

      final uploadResult = await uploadProvider.uploadStory(
        description: 'Liburan seru ke pantai!',
        lat: -6.2000,
        lon: 106.8166,
      );

      expect(uploadResult, isTrue);
      expect(uploadProvider.uploadSuccess, isTrue);
      expect(uploadProvider.errorMessage, isNull);
    });

    test('Upload cerita gagal jika belum memilih gambar', () async {
      final mockClient = MockClient((_) async => http.Response('{}', 200));
      final apiService = ApiService(client: mockClient);
      final uploadProvider = UploadProvider(apiService, authPreferences);

      final uploadResult = await uploadProvider.uploadStory(
        description: 'Deskripsi tanpa foto',
      );

      expect(uploadResult, isFalse);
      expect(uploadProvider.uploadSuccess, isFalse);
      expect(uploadProvider.errorMessage, equals('Please select an image first.'));
    });
  });
}

