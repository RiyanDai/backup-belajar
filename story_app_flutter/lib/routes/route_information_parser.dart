import 'package:flutter/widgets.dart';
import 'page_configuration.dart';

class StoryRouteInformationParser
    extends RouteInformationParser<PageConfiguration> {
  @override
  Future<PageConfiguration> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;

    if (uri.pathSegments.isEmpty) {
      return const HomePageConfiguration();
    }

    switch (uri.pathSegments[0]) {
      case 'login':
        return const LoginPageConfiguration();
      case 'register':
        return const RegisterPageConfiguration();
      case 'add':
        return const AddStoryPageConfiguration();
      case 'location-picker':
        return const LocationPickerPageConfiguration();
      case 'map-detail':
        if (uri.pathSegments.length > 1) {
          final id = uri.pathSegments[1];
          return MapDetailPageConfiguration(id);
        }
        return const HomePageConfiguration();
      case 'story':
        if (uri.pathSegments.length > 1) {
          final id = uri.pathSegments[1];
          return DetailStoryPageConfiguration(id);
        }
        return const HomePageConfiguration();
      default:
        return const HomePageConfiguration();
    }
  }

  @override
  RouteInformation? restoreRouteInformation(PageConfiguration configuration) {
    return switch (configuration) {
      SplashPageConfiguration() => RouteInformation(uri: Uri.parse('/splash')),
      LoginPageConfiguration() => RouteInformation(uri: Uri.parse('/login')),
      RegisterPageConfiguration() =>
        RouteInformation(uri: Uri.parse('/register')),
      HomePageConfiguration() => RouteInformation(uri: Uri.parse('/')),
      DetailStoryPageConfiguration(:final id) =>
        RouteInformation(uri: Uri.parse('/story/$id')),
      AddStoryPageConfiguration() => RouteInformation(uri: Uri.parse('/add')),
      LocationPickerPageConfiguration() =>
        RouteInformation(uri: Uri.parse('/location-picker')),
      MapDetailPageConfiguration(:final id) =>
        RouteInformation(uri: Uri.parse('/map-detail/$id')),
    };
  }
}

