import 'package:flutter/material.dart';

/// Global provider managing active application locale.
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  /// Active Flutter [Locale].
  Locale get locale => _locale;

  /// Sets the application language.
  void setLocale(Locale newLocale) {
    if (_locale == newLocale) return;
    _locale = newLocale;
    notifyListeners();
  }
}
