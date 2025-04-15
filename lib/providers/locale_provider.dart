import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!supportedLocales.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

  static const supportedLocales = [
    Locale('en'), // English
    Locale('ru'), // Russian
    Locale('es'), // Spanish
  ];
}