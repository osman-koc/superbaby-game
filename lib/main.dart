import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:superbaby/constants/app_settings.dart';
import 'package:superbaby/constants/assets.dart';
import 'package:superbaby/helpers/high_scores.dart';
import 'package:superbaby/my_game.dart';
import 'package:superbaby/navigation/routes.dart';
import 'package:superbaby/ui/game_over_menu.dart';
import 'package:superbaby/ui/pause_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await HighScores.load();
  await Assets.load();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.routes,
      supportedLocales: AppSettings.supportedLocales,
      localizationsDelegates: AppSettings.localizationsDelegates,
      localeResolutionCallback: AppSettings.localeResolutionCallback,
    ),
  );
}

class MyGameWidget extends StatelessWidget {
  const MyGameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppSettings.defaultContext = context;
    final myGame = MyGame();

    return GestureDetector(
      onPanUpdate: (details) {
        var dxPosition = details.globalPosition.dx;
        if (kDebugMode) {
          print('====> $dxPosition - ${myGame.hero.accelerationX}');
        }
        myGame.hero.setDirection(details.delta.dx);
      },
      onLongPressEnd: (details) {
        myGame.hero.accelerationX = 0;
      },
      child: getGameWidget(myGame),
    );
  }

  GameWidget<MyGame> getGameWidget(MyGame gameObj) {
    return GameWidget(
      game: gameObj,
      overlayBuilderMap: {
        'GameOverMenu': (context, MyGame game) {
          return GameOverMenu(game: game);
        },
        'PauseMenu': (context, MyGame game) {
          return PauseMenu(game: game);
        }
      },
    );
  }
}
