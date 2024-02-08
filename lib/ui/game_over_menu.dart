import 'package:flutter/material.dart';
import 'package:superbaby/extensions/app_lang.dart';
import 'package:superbaby/helpers/high_scores.dart';
import 'package:superbaby/my_game.dart';
import 'package:superbaby/navigation/routes.dart';
import 'package:superbaby/ui/widgets/my_button.dart';
import 'package:superbaby/ui/widgets/my_text.dart';

class GameOverMenu extends StatelessWidget {
  final MyGame game;

  const GameOverMenu({
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
                MyText(
                  context.translate.gameOver,
                  fontSize: 56,
                ),
                Table(
                  // border: TableBorder.all(),
                  columnWidths: const {
                    0: FlexColumnWidth(.2),
                    1: FlexColumnWidth(.5),
                    2: FlexColumnWidth(.2),
                    3: FlexColumnWidth(.1),
                  },
                  children: [
                    TableRow(
                      children: [
                        const SizedBox(),
                        MyText(context.translate.score),
                        MyText(game.score.toString()),
                        const SizedBox(),
                      ],
                    ),
                    TableRow(
                      children: [
                        const SizedBox(),
                        MyText(context.translate.bestScore),
                        MyText('${HighScores.highScores[0]}'),
                        const SizedBox(),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 40),
                MyButton(
                  context.translate.tryAgain,
                  onPressed: () => context.pushAndRemoveUntil(Routes.game),
                ),
                const SizedBox(height: 40),
                MyButton(
                  context.translate.menu,
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
