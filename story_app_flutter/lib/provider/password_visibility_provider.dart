import 'package:flutter/foundation.dart';

class PasswordVisibilityProvider extends ChangeNotifier {
  bool _obscureText = true;

  bool get obscureText => _obscureText;

  void toggle() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  void setObscure(bool value) {
    if (_obscureText != value) {
      _obscureText = value;
      notifyListeners();
    }
  }
}

