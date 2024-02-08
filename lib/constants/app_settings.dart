import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:superbaby/util/localization.dart';

class AppSettings {
  static BuildContext? defaultContext;

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('tr'),
  ];

  static const List<LocalizationsDelegate> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static Locale? localeResolutionCallback(locale, supportedLocales) {
    if (locale != null) {
      final currentLocale = supportedLocales
          .firstWhere((x) => x.languageCode == locale.languageCode);
      if (currentLocale != null) return currentLocale;
    }
    return supportedLocales.first;
  }
}
