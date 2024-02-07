import 'package:flutter/material.dart';
import 'package:superbaby/my_game.dart';
import 'package:superbaby/navigation/routes.dart';
import 'package:superbaby/ui/widgets/my_button.dart';
import 'package:superbaby/ui/widgets/my_text.dart';

class PauseMenu extends StatelessWidget {
  final MyGame game;

  const PauseMenu({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Material(
      color: Colors.black38,
      child: Center(
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                SizedBox(height: height * .15),
                const MyText(
                  'Durdur',
                  fontSize: 56,
                ),
                const SizedBox(height: 40),
                MyButton(
                  'Devam et',
                  onPressed: () {
                    game.overlays.remove('PauseMenu');
                    game.paused = false;
                  },
                ),
                const SizedBox(height: 40),
                MyButton(
                  'Menü',
                  onPressed: () => context.pushAndRemoveUntil(Routes.main),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
