import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common/flavor_config.dart';
import 'common/styles.dart';
import 'common/url_strategy.dart';
import 'data/api/api_service.dart';
import 'data/preferences/auth_preferences.dart';
import 'l10n/app_localizations.dart';
import 'provider/auth_provider.dart';
import 'provider/localization_provider.dart';
import 'provider/location_picker_provider.dart';
import 'provider/story_map_provider.dart';
import 'provider/story_provider.dart';
import 'provider/upload_provider.dart';
import 'routes/route_information_parser.dart';
import 'routes/router_delegate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureAppUrlStrategy();

  FlavorConfig.initialize(flavor: FlavorType.paid, appTitle: 'Story App Pro');

  final authPreferences = await AuthPreferences.init();
  final apiService = ApiService();

  runApp(MyApp(authPreferences: authPreferences, apiService: apiService));
}

class MyApp extends StatefulWidget {
  final AuthPreferences authPreferences;
  final ApiService apiService;

  const MyApp({
    super.key,
    required this.authPreferences,
    required this.apiService,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final StoryRouterDelegate _routerDelegate;
  late final StoryRouteInformationParser _routeInformationParser;

  @override
  void initState() {
    super.initState();
    _routerDelegate = StoryRouterDelegate(widget.authPreferences);
    _routeInformationParser = StoryRouteInformationParser();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocalizationProvider(widget.authPreferences),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              AuthProvider(widget.apiService, widget.authPreferences),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              StoryProvider(widget.apiService, widget.authPreferences),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              UploadProvider(widget.apiService, widget.authPreferences),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationPickerProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => StoryMapProvider(),
        ),
      ],
      child: Consumer<LocalizationProvider>(
        builder: (context, localizationProvider, _) {
          return MaterialApp.router(
            title: FlavorConfig.instance.appTitle,
            debugShowCheckedModeBanner: false,
            theme: appThemeData,
            locale: localizationProvider.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerDelegate: _routerDelegate,
            routeInformationParser: _routeInformationParser,
            backButtonDispatcher: RootBackButtonDispatcher(),
          );
        },
      ),
    );
  }
}
