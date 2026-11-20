import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app_flutter/common/result_state.dart';
import 'package:story_app_flutter/data/api/api_service.dart';
import 'package:story_app_flutter/data/preferences/auth_preferences.dart';
import 'package:story_app_flutter/provider/story_provider.dart';

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

  group('StoryProvider Tests', () {
    test('Menampilkan daftar cerita dari API dengan benar', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.endsWith('/stories') && request.method == 'GET') {
          return http.Response(
            jsonEncode({
              'error': false,
              'message': 'Stories fetched successfully',
              'listStory': [
                {
                  'id': 'story-001',
                  'name': 'Dimas',
                  'description': 'Cerita pertama di Story App',
                  'photoUrl': 'https://story-api.dicoding.dev/images/001.jpg',
                  'createdAt': '2026-11-13T10:00:00.000Z',
                  'lat': -6.2088,
                  'lon': 106.8456,
                },
                {
                  'id': 'story-002',
                  'name': 'Aulia',
                  'description': 'Pemandangan sore yang indah',
                  'photoUrl': 'https://story-api.dicoding.dev/images/002.jpg',
                  'createdAt': '2026-11-13T11:00:00.000Z',
                  'lat': null,
                  'lon': null,
                },
              ],
            }),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      final apiService = ApiService(client: mockClient);
      final storyProvider = StoryProvider(apiService, authPreferences);

      expect(storyProvider.storiesState, equals(ResultState.initial));

      await storyProvider.fetchAllStories();

      expect(storyProvider.storiesState, equals(ResultState.hasData));
      expect(storyProvider.stories.length, equals(2));
      expect(storyProvider.stories[0].id, equals('story-001'));
      expect(storyProvider.stories[0].name, equals('Dimas'));
      expect(storyProvider.stories[0].lat, equals(-6.2088));
      expect(storyProvider.stories[1].id, equals('story-002'));
      expect(storyProvider.storiesError, isNull);
    });

    test('Menampilkan data detail ketika item cerita ditekan / diambil',
        () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.endsWith('/stories/story-001') &&
            request.method == 'GET') {
          return http.Response(
            jsonEncode({
              'error': false,
              'message': 'Story fetched successfully',
              'story': {
                'id': 'story-001',
                'name': 'Dimas',
                'description': 'Cerita pertama lengkap di Story App',
                'photoUrl': 'https://story-api.dicoding.dev/images/001.jpg',
                'createdAt': '2026-11-13T10:00:00.000Z',
                'lat': -6.2088,
                'lon': 106.8456,
              },
            }),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      final apiService = ApiService(client: mockClient);
      final storyProvider = StoryProvider(apiService, authPreferences);

      expect(storyProvider.detailState, equals(ResultState.initial));

      await storyProvider.fetchStoryDetail('story-001');

      expect(storyProvider.detailState, equals(ResultState.hasData));
      expect(storyProvider.storyDetail, isNotNull);
      expect(storyProvider.storyDetail?.id, equals('story-001'));
      expect(storyProvider.storyDetail?.name, equals('Dimas'));
      expect(storyProvider.storyDetail?.description,
          equals('Cerita pertama lengkap di Story App'));
      expect(storyProvider.detailError, isNull);
    });
  });
}

