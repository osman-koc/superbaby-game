import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';
import 'package:superbaby/constants/game_constants.dart';
import 'package:superbaby/constants/assets.dart';
import 'package:superbaby/helpers/target_platform.dart';
import 'package:superbaby/my_game.dart';
import 'package:superbaby/objects/coin.dart';
import 'package:superbaby/objects/floor.dart';
import 'package:superbaby/objects/hearth_enemy.dart';
import 'package:superbaby/objects/jetpack_group.dart';
import 'package:superbaby/objects/lightning.dart';
import 'package:superbaby/objects/platform.dart';
import 'package:superbaby/objects/power_up.dart';
//import 'package:sensors_plus/sensors_plus.dart';

enum HeroState {
  jump,
  fall,
  dead,
}

const _durationJetpack = 3.0;

class MyHero extends BodyComponent<MyGame>
    with ContactCallbacks, KeyboardHandler {
  static final size = Vector2(.75, .80);

  var hState = HeroState.fall;

  late final SpriteComponent fallComponent;
  late final SpriteComponent jumpComponent;
  final jetpackComponent = JetpackGroup();
  final bubbleShieldComponent = SpriteComponent(
    sprite: Assets.bubble,
    size: Vector2(1, 1),
    anchor: Anchor.center,
    priority: 2,
  );

  late Component currentComponent;

  double accelerationX = 0;

  bool hasJetpack = false;
  bool hasBubbleShield = false;

  double durationJetpack = 0;

  //StreamSubscription? accelerometerSubscription;

  double minPositionX = 0.4;
  double maxPositionX = GameConstants.worldSize.x - 0.4;

  int positionCounter = 0;
  double lastXPosition = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;

    if (isMobile || isWeb) {
      // accelerometerSubscription = accelerometerEventStream().listen((event) {
      //   accelerationX = (event.x * -1).clamp(-0.5, 0.5);
      // });
    }

    fallComponent = SpriteComponent(
      sprite: Assets.heroFall,
      size: size,
      anchor: Anchor.center,
    );

    jumpComponent = SpriteComponent(
      sprite: Assets.heroJump,
      size: size,
      anchor: Anchor.center,
    );

    currentComponent = fallComponent;
    add(currentComponent);
  }

  void jump() {
    if (hState == HeroState.jump || hState == HeroState.dead) return;
    final velocity = body.linearVelocity;
    body.linearVelocity = Vector2(velocity.x, -7.5);
    hState = HeroState.jump;
  }

  void hit() {
    if (hasJetpack) return;
    if (hState == HeroState.dead) return;

    if (hasBubbleShield) {
      hasBubbleShield = false;
      remove(bubbleShieldComponent);
      return;
    }

    hState = HeroState.dead;
    body.setFixedRotation(false);
    body.applyAngularImpulse(2);
  }

  void takeJetpack() {
    if (hState == HeroState.dead) return;
    durationJetpack = 0;
    if (!hasJetpack) add(jetpackComponent);
    hasJetpack = true;
  }

  void takeBubbleShield() {
    if (hState == HeroState.dead) return;
    if (!hasBubbleShield) add(bubbleShieldComponent);
    hasBubbleShield = true;
  }

  void takeCoin() {
    if (hState == HeroState.dead) return;
    game.coins++;
    final velocity = body.linearVelocity;
    body.linearVelocity = Vector2(velocity.x, -8.5);
  }

  void takeBullet() {
    if (hState == HeroState.dead) return;
    game.bullets += 25;
  }

  void fireBullet() {
    if (hState == HeroState.dead) return;
    game.addBullets();
  }

  @override
  void update(double dt) {
    super.update(dt);

    final velocity = body.linearVelocity;
    final position = body.position;

    if (position.y >= 8.97 && position.y <= 8.99) {
      positionCounter++;
    } else {
      positionCounter = 0;
    }

    if (velocity.y > 0.1 && hState != HeroState.dead) {
      hState = HeroState.fall;
    }

    if (hasJetpack) {
      durationJetpack += dt;
      if (durationJetpack >= _durationJetpack) {
        hasJetpack = false;
        remove(jetpackComponent);
      }
      velocity.y = -7.5;
    }

    velocity.x = accelerationX * 5;
    body.linearVelocity = velocity;

    if (position.x > GameConstants.worldSize.x) {
      //position.x = 0;
      position.x = maxPositionX;
      body.setTransform(position, 0);
      setDirection(-0.1);
    } else if (position.x < 0) {
      //position.x = GameConstants.worldSize.x;
      position.x = minPositionX;
      body.setTransform(position, 0);
      setDirection(0.1);
    } else if (positionCounter == 3) {
      hit();
    }

    if (hState == HeroState.jump) {
      _setComponent(jumpComponent);
    } else if (hState == HeroState.fall) {
      _setComponent(fallComponent);
    } else if (hState == HeroState.dead) {
      _setComponent(fallComponent);
    }
  }

  void _setComponent(PositionComponent component) {
    if (accelerationX > 0) {
      if (!component.isFlippedHorizontally) {
        component.flipHorizontally();
      }
    } else {
      if (component.isFlippedHorizontally) {
        component.flipHorizontally();
      }
    }

    if (component == currentComponent) return;
    remove(currentComponent);
    currentComponent = component;
    add(component);
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(
          GameConstants.worldSize.x / 2, GameConstants.worldSize.y - 0.5),
      type: BodyType.dynamic,
    );

    final shape = PolygonShape()..setAsBoxXY(.27, .30);

    final fixtureDef = FixtureDef(shape)
      ..density = 10
      ..friction = 0
      ..restitution = 0;
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..setFixedRotation(true);
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is HearthEnemy) {
      if (hasBubbleShield) {
        other.destroy = true;
      }
      hit();
    }
    if (other is Lightning) {
      hit();
    }
    if (other is Floor) jump();

    if (other is PowerUp) {
      if (other.type == PowerUpType.jetpack) {
        takeJetpack();
      }
      if (other.type == PowerUpType.bubble) {
        takeBubbleShield();
      }
      if (other.type == PowerUpType.gun) {
        takeBullet();
      }
      other.take();
    }

    if (other is Coin) {
      if (!other.isTaken) {
        takeCoin();
        other.take();
      }
    }

    if (other is Platform) {
      if (hState == HeroState.fall && other.type.isBroken) {
        other.destroy = true;
      }
      jump();
    }
  }

  @override
  void preSolve(Object other, Contact contact, Manifold oldManifold) {
    if (other is Platform) {
      final heroY = body.position.y - size.y / 2;
      final platformY = other.body.position.y + Platform.size.y / 2;

      if (heroY < platformY) {
        contact.isEnabled = false;
      }
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      accelerationX = 1;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      accelerationX = -1;
    } else {
      accelerationX = 0;
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyR)) {
      fireBullet();
    }

    return false;
  }

  void cancelSensor() {
    //accelerometerSubscription?.cancel();
  }

  void setDirection(double deltaX /*double touchPositionX*/) {
    //if (GameConstants.isOnTheLeft(touchPositionX)) {
    if (deltaX < 0) {
      accelerationX = (accelerationX - 0.2).clamp(-0.5, 0.5);
    } else if (deltaX > 0) {
      accelerationX = (accelerationX + 0.2).clamp(-0.5, 0.5);
    } else {
      accelerationX = 0;
    }
  }
}
