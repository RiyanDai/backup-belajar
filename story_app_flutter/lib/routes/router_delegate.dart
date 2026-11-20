import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../data/model/story_response.dart';
import '../data/preferences/auth_preferences.dart';
import '../l10n/app_localizations.dart';
import '../provider/auth_provider.dart';
import '../provider/localization_provider.dart';
import '../ui/add/add_story_screen.dart';
import '../ui/auth/login_screen.dart';
import '../ui/auth/register_screen.dart';
import '../ui/maps/location_picker_screen.dart';
import '../ui/maps/story_map_detail_screen.dart';
import '../ui/splash/splash_screen.dart';
import '../ui/story/story_detail_screen.dart';
import '../ui/story/story_list_screen.dart';
import '../ui/widgets/animated_dialogs.dart';
import '../ui/widgets/custom_notification.dart';
import 'dialog_page.dart';
import 'page_configuration.dart';

class StoryRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<PageConfiguration> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AuthPreferences _authPreferences;

  bool? _isLoggedIn;
  bool _isRegister = false;
  String? _selectedStoryId;
  bool _isAddingStory = false;
  bool _isLogoutDialogOpen = false;
  bool _isLanguageDialogOpen = false;
  bool _isLocationPickerOpen = false;
  Story? _selectedMapDetailStory;
  String? _selectedMapDetailAddress;

  void Function(LatLng)? _onLocationPicked;

  StoryRouterDelegate(this._authPreferences)
    : navigatorKey = GlobalKey<NavigatorState>() {
    _initSession();
  }

  Future<void> _initSession() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _isLoggedIn = _authPreferences.isLoggedIn();
    notifyListeners();
  }

  bool? get isLoggedIn => _isLoggedIn;
  bool get isRegister => _isRegister;
  String? get selectedStoryId => _selectedStoryId;
  bool get isAddingStory => _isAddingStory;
  bool get isLogoutDialogOpen => _isLogoutDialogOpen;
  bool get isLanguageDialogOpen => _isLanguageDialogOpen;
  bool get isLocationPickerOpen => _isLocationPickerOpen;
  Story? get selectedMapDetailStory => _selectedMapDetailStory;

  void toLogin() {
    _isLoggedIn = false;
    _isRegister = false;
    _isLogoutDialogOpen = false;
    _isLanguageDialogOpen = false;
    _selectedMapDetailStory = null;
    _selectedMapDetailAddress = null;
    notifyListeners();
  }

  void toRegister() {
    _isRegister = true;
    notifyListeners();
  }

  void toHome() {
    _isLoggedIn = true;
    _isRegister = false;
    _selectedStoryId = null;
    _isAddingStory = false;
    _isLogoutDialogOpen = false;
    _isLanguageDialogOpen = false;
    _isLocationPickerOpen = false;
    _selectedMapDetailStory = null;
    _selectedMapDetailAddress = null;
    notifyListeners();
  }

  void toDetail(String storyId) {
    _selectedStoryId = storyId;
    _selectedMapDetailStory = null;
    _selectedMapDetailAddress = null;
    notifyListeners();
  }

  void toMapDetail(Story story, [String? address]) {
    _selectedMapDetailStory = story;
    _selectedMapDetailAddress = address;
    notifyListeners();
  }

  void toHideMapDetail() {
    _selectedMapDetailStory = null;
    _selectedMapDetailAddress = null;
    notifyListeners();
  }

  void toAddStory() {
    _isAddingStory = true;
    notifyListeners();
  }

  void toShowLogoutDialog() {
    _isLogoutDialogOpen = true;
    notifyListeners();
  }

  void toHideLogoutDialog() {
    _isLogoutDialogOpen = false;
    notifyListeners();
  }

  void toShowLanguageDialog() {
    _isLanguageDialogOpen = true;
    notifyListeners();
  }

  void toHideLanguageDialog() {
    _isLanguageDialogOpen = false;
    notifyListeners();
  }

  void toShowLocationPicker({required void Function(LatLng) onLocationPicked}) {
    _onLocationPicked = onLocationPicked;
    _isLocationPickerOpen = true;
    notifyListeners();
  }

  void toHideLocationPicker() {
    _isLocationPickerOpen = false;
    _onLocationPicked = null;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _selectedStoryId = null;
    _isAddingStory = false;
    _isRegister = false;
    _isLogoutDialogOpen = false;
    _isLanguageDialogOpen = false;
    _isLocationPickerOpen = false;
    _selectedMapDetailStory = null;
    _selectedMapDetailAddress = null;
    notifyListeners();
  }

  @override
  Future<bool> popRoute() async {
    if (_isLogoutDialogOpen) {
      _isLogoutDialogOpen = false;
      notifyListeners();
      return true;
    }
    if (_isLanguageDialogOpen) {
      _isLanguageDialogOpen = false;
      notifyListeners();
      return true;
    }
    if (_selectedMapDetailStory != null) {
      toHideMapDetail();
      return true;
    }
    if (_isLocationPickerOpen) {
      toHideLocationPicker();
      return true;
    }
    if (_isRegister) {
      _isRegister = false;
      notifyListeners();
      return true;
    }
    if (_selectedStoryId != null) {
      _selectedStoryId = null;
      notifyListeners();
      return true;
    }
    if (_isAddingStory) {
      _isAddingStory = false;
      notifyListeners();
      return true;
    }
    return false;
  }

  @override
  PageConfiguration? get currentConfiguration {
    if (_isLoggedIn == null) {
      return const SplashPageConfiguration();
    }
    if (_isLoggedIn == false) {
      return _isRegister
          ? const RegisterPageConfiguration()
          : const LoginPageConfiguration();
    }
    if (_selectedMapDetailStory != null) {
      return MapDetailPageConfiguration(_selectedMapDetailStory!.id);
    }
    if (_isAddingStory) {
      return const AddStoryPageConfiguration();
    }
    if (_selectedStoryId != null) {
      return DetailStoryPageConfiguration(_selectedStoryId!);
    }
    return const HomePageConfiguration();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (_isLoggedIn == null)
          const MaterialPage(
            key: ValueKey('SplashPage'),
            name: '/splash',
            child: SplashScreen(),
          )
        else if (_isLoggedIn == false) ...[
          MaterialPage(
            key: const ValueKey('LoginPage'),
            name: '/login',
            child: LoginScreen(
              onRegisterTap: () {
                _isRegister = true;
                notifyListeners();
              },
              onLoginSuccess: () {
                _isLoggedIn = true;
                _isRegister = false;
                notifyListeners();
              },
            ),
          ),
          if (_isRegister)
            MaterialPage(
              key: const ValueKey('RegisterPage'),
              name: '/register',
              child: RegisterScreen(
                onLoginTap: () {
                  _isRegister = false;
                  notifyListeners();
                },
              ),
            ),
        ] else ...[
          MaterialPage(
            key: const ValueKey('StoryListPage'),
            name: '/',
            child: StoryListScreen(
              onStoryTap: (storyId) {
                _selectedStoryId = storyId;
                notifyListeners();
              },
              onAddStoryTap: () {
                _isAddingStory = true;
                notifyListeners();
              },
              onShowLogoutDialog: () {
                toShowLogoutDialog();
              },
              onShowLanguageDialog: () {
                toShowLanguageDialog();
              },
            ),
          ),
          if (_selectedStoryId != null)
            MaterialPage(
              key: ValueKey('DetailStoryPage_$_selectedStoryId'),
              name: '/story/$_selectedStoryId',
              child: StoryDetailScreen(
                storyId: _selectedStoryId!,
                onBack: () {
                  _selectedStoryId = null;
                  notifyListeners();
                },
                onOpenMapDetail: (story, address) {
                  toMapDetail(story, address);
                },
              ),
            ),
          if (_selectedMapDetailStory != null)
            MaterialPage(
              key: ValueKey('MapDetailPage_${_selectedMapDetailStory!.id}'),
              name: '/map-detail/${_selectedMapDetailStory!.id}',
              child: StoryMapDetailScreen(
                story: _selectedMapDetailStory!,
                initialAddress: _selectedMapDetailAddress,
                onBack: () {
                  toHideMapDetail();
                },
              ),
            ),
          if (_isAddingStory)
            MaterialPage(
              key: const ValueKey('AddStoryPage'),
              name: '/add',
              child: AddStoryScreen(
                onUploadSuccess: () {
                  _isAddingStory = false;
                  notifyListeners();
                },
                onBack: () {
                  _isAddingStory = false;
                  notifyListeners();
                },
                onPickLocation: (onPicked) {
                  toShowLocationPicker(onLocationPicked: onPicked);
                },
              ),
            ),
          if (_isLocationPickerOpen)
            MaterialPage(
              key: const ValueKey('LocationPickerPage'),
              name: '/location-picker',
              child: LocationPickerScreen(
                onLocationPicked: (latLng) {
                  _onLocationPicked?.call(latLng);
                  toHideLocationPicker();
                },
                onCancel: () {
                  toHideLocationPicker();
                },
              ),
            ),
          if (_isLogoutDialogOpen)
            DialogPage(
              key: const ValueKey('LogoutDialogPage'),
              name: '/logout-dialog',
              child: Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  return AnimatedLogoutDialog(
                    title: l10n.logoutConfirmTitle,
                    message: l10n.logoutConfirmMessage,
                    cancelText: l10n.cancel,
                    logoutText: l10n.logout,
                    onCancel: () {
                      toHideLogoutDialog();
                    },
                    onConfirmLogout: () async {
                      toHideLogoutDialog();
                      await context.read<AuthProvider>().logout();
                      if (context.mounted) {
                        AppNotification.showInfo(
                          context,
                          title: l10n.logout,
                          message: l10n.success,
                        );
                      }
                      logout();
                    },
                  );
                },
              ),
            ),
          if (_isLanguageDialogOpen)
            DialogPage(
              key: const ValueKey('LanguageDialogPage'),
              name: '/language-dialog',
              child: Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  final locProvider = context.read<LocalizationProvider>();
                  return AnimatedLanguageDialog(
                    title: l10n.language,
                    indonesianLabel: l10n.indonesian,
                    englishLabel: l10n.english,
                    currentLocaleCode: locProvider.locale.languageCode,
                    onSelectLanguage: (code) {
                      locProvider.setLocale(Locale(code));
                      toHideLanguageDialog();
                      if (context.mounted) {
                        AppNotification.showSuccess(
                          context,
                          title: l10n.language,
                          message: code == 'id'
                              ? l10n.indonesian
                              : l10n.english,
                        );
                      }
                    },
                    onDismiss: () {
                      toHideLanguageDialog();
                    },
                  );
                },
              ),
            ),
        ],
      ],
      onDidRemovePage: (page) {
        if (page.name == '/register') {
          _isRegister = false;
          notifyListeners();
        } else if (page.name?.startsWith('/story/') ?? false) {
          _selectedStoryId = null;
          notifyListeners();
        } else if (page.name == '/add') {
          _isAddingStory = false;
          notifyListeners();
        } else if (page.name == '/location-picker') {
          _isLocationPickerOpen = false;
          _onLocationPicked = null;
          notifyListeners();
        } else if (page.name?.startsWith('/map-detail') ?? false) {
          _selectedMapDetailStory = null;
          _selectedMapDetailAddress = null;
          notifyListeners();
        } else if (page.name == '/logout-dialog') {
          _isLogoutDialogOpen = false;
          notifyListeners();
        } else if (page.name == '/language-dialog') {
          _isLanguageDialogOpen = false;
          notifyListeners();
        }
      },
    );
  }

  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) async {
    switch (configuration) {
      case SplashPageConfiguration():
        break;
      case LoginPageConfiguration():
        _isRegister = false;
        break;
      case RegisterPageConfiguration():
        _isRegister = true;
        break;
      case HomePageConfiguration():
        _selectedStoryId = null;
        _isAddingStory = false;
        _isLogoutDialogOpen = false;
        _isLanguageDialogOpen = false;
        _isLocationPickerOpen = false;
        break;
      case DetailStoryPageConfiguration(:final id):
        _selectedStoryId = id;
        _isAddingStory = false;
        break;
      case AddStoryPageConfiguration():
        _isAddingStory = true;
        _selectedStoryId = null;
        break;
      case LocationPickerPageConfiguration():
        _isLocationPickerOpen = true;
        break;
      case MapDetailPageConfiguration(:final id):
        _selectedStoryId = id;
        break;
    }
  }
}
