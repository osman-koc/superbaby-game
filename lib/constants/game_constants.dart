import 'package:flame/components.dart';
import 'package:flame/input.dart';

class GameConstants {
  static const int dangerObjectCount = 3;
  static final Vector2 worldSize = Vector2(4.28, 9.26);
  static final Vector2 screenSize = Vector2(428, 926);
  
  static double screenBeginX = 20;
  static double screenMiddleX = screenSize.x / 2;
  static double screenEndX = screenSize.x;

  static bool isOnTheLeft(double positionX) => positionX > screenBeginX && positionX < screenMiddleX;
  static bool isOnTheRight(double positionX) => positionX > screenMiddleX && positionX < screenEndX;
}
