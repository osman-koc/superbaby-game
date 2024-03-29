import 'dart:core';

import 'package:flutter/material.dart';
import 'package:superbaby/constants/app_settings.dart';
import 'package:superbaby/extensions/app_lang.dart';
import 'package:superbaby/main.dart';
import 'package:superbaby/ui/leaderboards_screen.dart';
import 'package:superbaby/ui/main_menu_screen.dart';

enum Routes {
  main('/'),
  game('/game'),
  leaderboard('/leaderboard');

  final String route;

  const Routes(this.route);

  static Route routes(RouteSettings settings) {
    MaterialPageRoute buildRoute(Widget widget) {
      return MaterialPageRoute(builder: (_) => widget, settings: settings);
    }

    final routeName = Routes.values.firstWhere((e) => e.route == settings.name);

    switch (routeName) {
      case Routes.main:
        return buildRoute(const MainMenuScreen());
      case Routes.game:
        return buildRoute(const MyGameWidget());
      case Routes.leaderboard:
        return buildRoute(const LeaderboardScreen());
      default:
        String errorMessage =
            AppSettings.defaultContext?.translate.routeDoesNotExists ??
                'Route does not exists';
        throw Exception(errorMessage);
    }
  }
}

extension BuildContextExtension on BuildContext {
  void pushAndRemoveUntil(Routes route) {
    Navigator.pushNamedAndRemoveUntil(this, route.route, (route) => false);
  }

  void push(Routes route) {
    Navigator.pushNamed(this, route.route);
  }
}
