import 'package:superbaby/constants/app_settings.dart';

class AssetConstants {
  static const String background = 'assets/ui/background.png';
  static const String heroJump = 'assets/ui/heroJump.png';
  static const String landPieceDarkMulticolored =
      'assets/ui/LandPiece_DarkMulticolored.png';
  static const String brokenLandPieceBeige =
      'assets/ui/BrokenLandPiece_Beige.png';
  static const String landPieceDarkBlue = 'assets/ui/LandPiece_DarkBlue.png';
  static const String happyCloud = 'assets/ui/HappyCloud.png';

  static String title = 'assets/ui/title_${AppSettings.getPlatformLocaleCountryCode()}.png';
  static String atlasMap = 'atlasMap_${AppSettings.getPlatformLocaleCountryCode()}.atlas';
}
