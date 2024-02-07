import 'package:flame/components.dart';
import 'package:superbaby/constants/assets.dart';
import 'package:superbaby/my_game.dart';

class Background extends SpriteComponent {
  Background() : super(sprite: Assets.background);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = screenSize;
  }
}
