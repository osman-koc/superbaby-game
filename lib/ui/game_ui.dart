import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:superbaby/constants/app_settings.dart';
import 'package:superbaby/constants/game_constants.dart';
import 'package:superbaby/constants/assets.dart';
import 'package:superbaby/extensions/app_lang.dart';
import 'package:superbaby/helpers/target_platform.dart';
import 'package:superbaby/my_game.dart';
import 'package:superbaby/objects/hero.dart';

final textPaint = TextPaint(
  style: const TextStyle(
    color: Colors.black,
    fontSize: 35,
    fontWeight: FontWeight.w800,
    fontFamily: 'DaveysDoodleface',
  ),
);

class GameUI extends PositionComponent with HasGameRef<MyGame> {
  final MyHero hero;
  GameUI(this.hero) : super();

  // Keep track of the number of bodies in the world.
  final totalBodies =
      TextComponent(position: Vector2(5, 865), textRenderer: textPaint);

  final totalScore = TextComponent(textRenderer: textPaint);

  final totalCoins = TextComponent(textRenderer: textPaint);

  final totalBullets = TextComponent(textRenderer: textPaint);

  final coin = SpriteComponent(sprite: Assets.coin, size: Vector2.all(25));
  final gun = SpriteComponent(sprite: Assets.gun, size: Vector2.all(35));

  // Keep track of the frames per second
  final fps =
      FpsTextComponent(position: Vector2(5, 830), textRenderer: textPaint);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position.y = isIOS ? 25 : 0;
    final btPause = SpriteButtonComponent(
      button: Assets.buttonPause,
      buttonDown: Assets.buttonBack,
      size: Vector2(35, 35),
      position: Vector2(390, 50),
      priority: 10,
      onPressed: () {
        gameRef.overlays.add('PauseMenu');
        gameRef.paused = true;
      },
    );

    add(btPause);
    add(coin);
    add(gun);
    add(fps);
    add(totalBodies);
    add(totalScore);
    add(totalCoins);
    add(totalBullets);
  }

  @override
  void update(double dt) {
    super.update(dt);

    String bodiesText = AppSettings.defaultContext?.translate.bodies ?? "Bodies";
    String scoreText = AppSettings.defaultContext?.translate.score ?? "Score";

    totalBodies.text = '$bodiesText: ${game.world.physicsWorld.bodies.length}';
    totalScore.text = '$scoreText: ${gameRef.score}';
    totalCoins.text = 'x${gameRef.coins}';
    totalBullets.text = 'x${gameRef.bullets}';

    final posX = GameConstants.screenSize.x - totalCoins.size.x;
    totalCoins.position
      ..x = posX - 5
      ..y = 5;
    coin.position
      ..x = posX - 35
      ..y = 12;

    gun.position
      ..x = 5
      ..y = 12;
    totalBullets.position
      ..x = 40
      ..y = 8;

    totalScore.position
      ..x = GameConstants.screenSize.x / 2 - totalScore.size.x / 2
      ..y = 5;
  }

// @override
// void render(Canvas canvas) {
//   canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y),
//       BasicPalette.blue.paint());
// }
}
