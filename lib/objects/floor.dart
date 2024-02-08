import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:superbaby/constants/game_constants.dart';
import 'package:superbaby/my_game.dart';

class Floor extends BodyComponent<MyGame> {
  @override
  void update(double dt) {
    super.update(dt);

    if (game.isOutOfScreen(body.position)) {
      world.destroyBody(body);
      world.remove(this);
    }
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(0, GameConstants.worldSize.y),
      type: BodyType.static,
    );

    final shape = EdgeShape()..set(Vector2.zero(), Vector2(GameConstants.worldSize.x, 0));
    final fixtureDef = FixtureDef(shape);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
