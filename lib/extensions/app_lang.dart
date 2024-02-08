import 'package:flutter/material.dart';
import 'package:superbaby/util/localization.dart';

class AppLangTranslations {
  final AppLocalizations _appLocalizations;

  AppLangTranslations(this._appLocalizations);

  String get appName => _appLocalizations.translate(key: 'app_name');
  String get appDeveloper => _appLocalizations.translate(key: 'app_developer');
  String get appWebsite => _appLocalizations.translate(key: 'app_website');
  String get appMail => _appLocalizations.translate(key: 'app_email');
  String get loading => _appLocalizations.translate(key: 'loading');
  String get osmkocCom => _appLocalizations.translate(key: 'osmkoccom');
  String get about => _appLocalizations.translate(key: 'about');
  String get aboutAppTitle =>
      _appLocalizations.translate(key: 'about_app_title');
  String get developedBy => _appLocalizations.translate(key: 'developedby');
  String get contact => _appLocalizations.translate(key: 'contact');
  String get close => _appLocalizations.translate(key: 'close');

  String get routeDoesNotExists => _appLocalizations.translate(key: 'route_does_not_exists');
  String get wrongPlatformTypeException => _appLocalizations.translate(key: 'wrong_platform_type');

  String get gameOver => _appLocalizations.translate(key: 'game_over');
  String get score => _appLocalizations.translate(key: 'score');
  String get bestScore => _appLocalizations.translate(key: 'best_score');
  String get tryAgain => _appLocalizations.translate(key: 'try_again');
  String get menu => _appLocalizations.translate(key: 'menu');
  String get bodies => _appLocalizations.translate(key: 'bodies');
  String get bestScores => _appLocalizations.translate(key: 'best_scores');
  String get play => _appLocalizations.translate(key: 'play');
  String get scores => _appLocalizations.translate(key: 'scores');
  String get exit => _appLocalizations.translate(key: 'exit');
  String get paused => _appLocalizations.translate(key: 'paused');
  String get resume => _appLocalizations.translate(key: 'resume');
}

extension AppLangContextExtension on BuildContext {
  AppLangTranslations get translate =>
      AppLangTranslations(AppLocalizations.of(this));
}
