import 'package:flame/components.dart';
import 'package:superbaby/constants/game_constants.dart';
import 'package:superbaby/constants/assets.dart';

class Background extends SpriteComponent {
  Background() : super(sprite: Assets.background);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = GameConstants.screenSize;
  }
}
