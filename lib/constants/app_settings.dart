import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:superbaby/util/localization.dart';

class AppSettings {
  static BuildContext? defaultContext;
  static Locale? currentLocale;

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
      currentLocale = supportedLocales
          .firstWhere((x) => x.languageCode == locale.languageCode);
      if (currentLocale != null) return currentLocale;
    }
    return supportedLocales.first;
  }

  static String getPlatformLocaleCountryCode() =>
      Platform.localeName.split('_')[0];
}
