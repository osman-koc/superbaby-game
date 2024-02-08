import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:superbaby/constants/game_constants.dart';
import 'package:superbaby/constants/enums/game_state.dart';
import 'package:superbaby/helpers/high_scores.dart';
import 'package:superbaby/model/touch_model.dart';
import 'package:superbaby/objects/background.dart';
import 'package:superbaby/objects/bullet.dart';
import 'package:superbaby/objects/cloud_enemy.dart';
import 'package:superbaby/objects/coin.dart';
import 'package:superbaby/objects/floor.dart';
import 'package:superbaby/objects/hearth_enemy.dart';
import 'package:superbaby/objects/hero.dart';
import 'package:superbaby/objects/platform.dart';
import 'package:superbaby/objects/platform_pieces.dart';
import 'package:superbaby/objects/power_up.dart';
import 'package:superbaby/ui/game_ui.dart';

final random = Random();

class MyGame extends Forge2DGame
    with HasKeyboardHandlerComponents, TapCallbacks {
  late final MyHero hero;

  int score = 0;
  int coins = 0;
  int bullets = 0;
  double generatedWorldHeight = 6.7;

  TouchModel? touchModel;

  var state = GameState.running;

  // Scale the screenSize by 100 and set the gravity of 15
  MyGame()
      : super(
            zoom: 100,
            cameraComponent: CameraComponent.withFixedResolution(
              width: GameConstants.screenSize.x,
              height: GameConstants.screenSize.y,
            ),
            gravity: Vector2(0, 9.8));

  @override
  Future<void> onLoad() async {
    hero = MyHero();

    // Adds a black background to the viewport
    camera.backdrop.add(Background());
    camera.viewport.add(GameUI(hero));
    // camera.viewfinder.anchor = Anchor.center;

    world.add(Floor());

    // generateNextSectionOfWorld();

    world.add(hero);

    final worldBounds = Rectangle.fromLTRB(
      GameConstants.worldSize.x / 2,
      -double.infinity,
      GameConstants.worldSize.x / 2,
      GameConstants.worldSize.y / 2,
    );
    camera.follow(hero);
    camera.setBounds(worldBounds);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (state == GameState.running) {
      if (generatedWorldHeight > hero.body.position.y - GameConstants.worldSize.y / 2) {
        generateNextSectionOfWorld();
      }
      final heroY = (hero.body.position.y - GameConstants.worldSize.y) * -1;

      if (score < heroY) {
        score = heroY.toInt();
      }

      if (score - 7 > heroY) {
        hero.hit();
      }

      if (hero.state == HeroState.dead && (score - GameConstants.worldSize.y) > heroY) {
        state = GameState.gameOver;
        HighScores.saveNewScore(score);
        overlays.add('GameOverMenu');
      }

      if (touchModel?.isPressed ?? false) {
        hero.directionSet(touchModel!.positionX);
      }
    }
  }

  bool isOutOfScreen(Vector2 position) {
    final heroY = (hero.body.position.y - GameConstants.worldSize.y) * -1;
    final otherY = (position.y - GameConstants.worldSize.y) * -1;

    return otherY < heroY - GameConstants.worldSize.y / 2;

    // final heroPosY = (hero.body.position.y - worldSize.y).abs();
    // final otherPosY = (position.y - worldSize.y).abs();
    // return otherPosY < heroPosY - worldSize.y / 2;
  }

  void generateNextSectionOfWorld() {
    for (int i = 0; i < 10; i++) {
      world.add(Platform(
        x: GameConstants.worldSize.x * random.nextDouble(),
        y: generatedWorldHeight,
      ));
      if (random.nextDouble() < .8) {
        world.add(Platform(
          x: GameConstants.worldSize.x * random.nextDouble(),
          y: generatedWorldHeight - 3 + (random.nextDouble() * 6),
        ));
      }

      if (random.nextBool()) {
        world.add(HearthEnemy(
          x: GameConstants.worldSize.x * random.nextDouble(),
          y: generatedWorldHeight - 1.5,
        ));
      } else if (random.nextDouble() < .2) {
        world.add(CloudEnemy(
          x: GameConstants.worldSize.x * random.nextDouble(),
          y: generatedWorldHeight - 1.5,
        ));
      }
      if (random.nextDouble() < .3) {
        world.add(PowerUp(
          x: GameConstants.worldSize.x * random.nextDouble(),
          y: generatedWorldHeight - 1.5,
        ));
        if (random.nextDouble() < 21.2) {
          addCoins();
        }
      }

      generatedWorldHeight -= 2.7;
    }
  }

  void addBrokenPlatformPieces(Platform platform) {
    final x = platform.body.position.x;
    final y = platform.body.position.y;

    final leftSide = PlatformPieces(
      x: x - (PlatformPieces.size.x / 2),
      y: y,
      isLeftSide: true,
      type: platform.type,
    );

    final rightSide = PlatformPieces(
      x: x + (PlatformPieces.size.x / 2),
      y: y,
      isLeftSide: false,
      type: platform.type,
    );

    world.add(leftSide);
    world.add(rightSide);
  }

  void addCoins() {
    final rows = random.nextInt(15) + 1;
    final cols = random.nextInt(5) + 1;

    final x = (GameConstants.worldSize.x - (Coin.size.x * cols)) * random.nextDouble() +
        Coin.size.x / 2;

    for (int col = 0; col < cols; col++) {
      for (int row = 0; row <= rows; row++) {
        world.add(Coin(
          x: x + (col * Coin.size.x),
          y: generatedWorldHeight + (row * Coin.size.y) - 2,
        ));
      }
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    touchModel?.setPress(false);
    hero.fireBullet();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onLongTapDown(event);
    touchModel = TouchModel(true, event.devicePosition.x);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    super.onTapCancel(event);
    touchModel?.setPress(false);
  }

  void addBullets() {
    bullets -= 3;
    if (bullets < 0) bullets = 0;
    if (bullets == 0) return;
    final x = hero.body.position.x;
    final y = hero.body.position.y;

    world.add(Bullet(x: x, y: y, accelX: -1.5));
    world.add(Bullet(x: x, y: y, accelX: 0));
    world.add(Bullet(x: x, y: y, accelX: 1.5));
  }

  @override
  void onRemove() {
    super.onRemove();
    hero.cancelSensor();
  }
}
