import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app_flutter/data/model/story_response.dart';
import 'package:story_app_flutter/data/preferences/auth_preferences.dart';
import 'package:story_app_flutter/routes/page_configuration.dart';
import 'package:story_app_flutter/routes/route_information_parser.dart';
import 'package:story_app_flutter/routes/router_delegate.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Declarative Navigation (Navigator 2.0) Tests', () {
    test(
      'RouterDelegate mengelola stack deklaratif berdasarkan state auth',
      () async {
        SharedPreferences.setMockInitialValues({'is_logged_in': false});
        final prefs = await SharedPreferences.getInstance();
        final authPreferences = AuthPreferences(prefs);
        final routerDelegate = StoryRouterDelegate(authPreferences);

        routerDelegate.toLogin();
        expect(routerDelegate.isLoggedIn, isFalse);
        expect(routerDelegate.isRegister, isFalse);
        expect(
          routerDelegate.currentConfiguration,
          isA<LoginPageConfiguration>(),
        );

        routerDelegate.toRegister();
        expect(routerDelegate.isRegister, isTrue);
        expect(
          routerDelegate.currentConfiguration,
          isA<RegisterPageConfiguration>(),
        );

        routerDelegate.toHome();
        expect(routerDelegate.isLoggedIn, isTrue);
        expect(
          routerDelegate.currentConfiguration,
          isA<HomePageConfiguration>(),
        );

        routerDelegate.toDetail('story-xyz-789');
        expect(routerDelegate.selectedStoryId, equals('story-xyz-789'));
        final config = routerDelegate.currentConfiguration;
        expect(config, isA<DetailStoryPageConfiguration>());
        expect(
          (config as DetailStoryPageConfiguration).id,
          equals('story-xyz-789'),
        );

        routerDelegate.toAddStory();
        expect(routerDelegate.isAddingStory, isTrue);
        expect(
          routerDelegate.currentConfiguration,
          isA<AddStoryPageConfiguration>(),
        );

        routerDelegate.logout();
        expect(routerDelegate.isLoggedIn, isFalse);
        expect(routerDelegate.selectedStoryId, isNull);
        expect(routerDelegate.isAddingStory, isFalse);
        expect(
          routerDelegate.currentConfiguration,
          isA<LoginPageConfiguration>(),
        );
        routerDelegate.toHome();
        // 7. Test declarative back button popRoute()
        routerDelegate.toDetail('story-xyz-789');
        expect(routerDelegate.selectedStoryId, equals('story-xyz-789'));
        final didPopDetail = await routerDelegate.popRoute();
        expect(didPopDetail, isTrue);
        expect(routerDelegate.selectedStoryId, isNull);
        expect(routerDelegate.currentConfiguration, isA<HomePageConfiguration>());

        // 8. Test declarative dialogs (Logout and Language)
        routerDelegate.toShowLogoutDialog();
        expect(routerDelegate.isLogoutDialogOpen, isTrue);
        final didPopLogoutDialog = await routerDelegate.popRoute();
        expect(didPopLogoutDialog, isTrue);
        expect(routerDelegate.isLogoutDialogOpen, isFalse);

        routerDelegate.toShowLanguageDialog();
        expect(routerDelegate.isLanguageDialogOpen, isTrue);
        final didPopLanguageDialog = await routerDelegate.popRoute();
        expect(didPopLanguageDialog, isTrue);
        expect(routerDelegate.isLanguageDialogOpen, isFalse);

        routerDelegate.toShowLogoutDialog();
        expect(routerDelegate.isLogoutDialogOpen, isTrue);
        routerDelegate.toHideLogoutDialog();
        expect(routerDelegate.isLogoutDialogOpen, isFalse);

        routerDelegate.toShowLanguageDialog();
        expect(routerDelegate.isLanguageDialogOpen, isTrue);
        routerDelegate.toHideLanguageDialog();
        expect(routerDelegate.isLanguageDialogOpen, isFalse);

        // 9. Test declarative location picker
        routerDelegate.toShowLocationPicker(onLocationPicked: (_) {});
        expect(routerDelegate.isLocationPickerOpen, isTrue);
        final didPopLocationPicker = await routerDelegate.popRoute();
        expect(didPopLocationPicker, isTrue);
        expect(routerDelegate.isLocationPickerOpen, isFalse);

        // 10. Test declarative map detail
        const testStory = Story(
          id: 'story-map-123',
          name: 'Tester',
          description: 'Testing map detail',
          photoUrl: 'https://example.com/photo.jpg',
          createdAt: '2026-11-18T00:00:00.000Z',
          lat: -6.200000,
          lon: 106.816666,
        );
        routerDelegate.toMapDetail(testStory, 'Jakarta');
        expect(routerDelegate.selectedMapDetailStory?.id, equals('story-map-123'));
        expect(routerDelegate.currentConfiguration, isA<MapDetailPageConfiguration>());
        final didPopMapDetail = await routerDelegate.popRoute();
        expect(didPopMapDetail, isTrue);
        expect(routerDelegate.selectedMapDetailStory, isNull);
      },
    );

    test(
      'RouteInformationParser menguraikan dan memulihkan URL dengan benar',
      () async {
        final parser = StoryRouteInformationParser();

        final homeConfig = await parser.parseRouteInformation(
          RouteInformation(uri: Uri.parse('/')),
        );
        expect(homeConfig, isA<HomePageConfiguration>());

        final loginConfig = await parser.parseRouteInformation(
          RouteInformation(uri: Uri.parse('/login')),
        );
        expect(loginConfig, isA<LoginPageConfiguration>());

        final registerConfig = await parser.parseRouteInformation(
          RouteInformation(uri: Uri.parse('/register')),
        );
        expect(registerConfig, isA<RegisterPageConfiguration>());

        final detailConfig = await parser.parseRouteInformation(
          RouteInformation(uri: Uri.parse('/story/story-123')),
        );
        expect(detailConfig, isA<DetailStoryPageConfiguration>());
        expect(
          (detailConfig as DetailStoryPageConfiguration).id,
          equals('story-123'),
        );

        final addConfig = await parser.parseRouteInformation(
          RouteInformation(uri: Uri.parse('/add')),
        );
        expect(addConfig, isA<AddStoryPageConfiguration>());

        final locationPickerConfig = await parser.parseRouteInformation(
          RouteInformation(uri: Uri.parse('/location-picker')),
        );
        expect(locationPickerConfig, isA<LocationPickerPageConfiguration>());

        final mapDetailConfig = await parser.parseRouteInformation(
          RouteInformation(uri: Uri.parse('/map-detail/story-123')),
        );
        expect(mapDetailConfig, isA<MapDetailPageConfiguration>());
        expect(
          (mapDetailConfig as MapDetailPageConfiguration).id,
          equals('story-123'),
        );

        final restoredDetail = parser.restoreRouteInformation(
          const DetailStoryPageConfiguration('story-123'),
        );
        expect(restoredDetail?.uri.path, equals('/story/story-123'));

        final restoredLocationPicker = parser.restoreRouteInformation(
          const LocationPickerPageConfiguration(),
        );
        expect(restoredLocationPicker?.uri.path, equals('/location-picker'));

        final restoredMapDetail = parser.restoreRouteInformation(
          const MapDetailPageConfiguration('story-123'),
        );
        expect(restoredMapDetail?.uri.path, equals('/map-detail/story-123'));
      },
    );
  });
}
