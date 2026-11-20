import 'package:flutter/widgets.dart';
import '../data/preferences/auth_preferences.dart';

class LocalizationProvider extends ChangeNotifier {
  final AuthPreferences _authPreferences;

  late Locale _locale;

  LocalizationProvider(this._authPreferences) {
    final savedCode = _authPreferences.getLocaleCode();
    if (savedCode != null && (savedCode == 'id' || savedCode == 'en')) {
      _locale = Locale(savedCode);
    } else {
      _locale = const Locale('id');
    }
  }

  Locale get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    await _authPreferences.setLocaleCode(locale.languageCode);
    notifyListeners();
  }
}

