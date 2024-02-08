import 'dart:io';

import 'package:flutter/material.dart';
import 'package:superbaby/constants/assets_constants.dart';
import 'package:superbaby/extensions/app_lang.dart';
import 'package:superbaby/helpers/high_scores.dart';
import 'package:superbaby/navigation/routes.dart';
import 'package:superbaby/ui/widgets/my_button.dart';
import 'package:superbaby/ui/widgets/my_text.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AssetConstants.background),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: LayoutBuilder(builder: (context, constrains) {
                return Stack(
                  children: [
                    Positioned(
                      bottom: constrains.maxHeight * .25,
                      child: Image.asset(
                        AssetConstants.heroJump,
                        scale: 1.25,
                      ),
                    ),
                    Positioned(
                      bottom: constrains.maxHeight * .60,
                      child: Image.asset(
                        AssetConstants.landPieceDarkMulticolored,
                        scale: 1.25,
                      ),
                    ),
                    Positioned(
                      bottom: constrains.maxHeight * .05,
                      left: constrains.maxWidth * .2,
                      child: Image.asset(
                        AssetConstants.brokenLandPieceBeige,
                        scale: 1.25,
                      ),
                    ),
                    Positioned(
                      bottom: constrains.maxHeight * .3,
                      right: 0,
                      child: Image.asset(
                        AssetConstants.landPieceDarkBlue,
                        scale: 1.5,
                      ),
                    ),
                    Positioned(
                      top: constrains.maxHeight * .3,
                      right: 0,
                      child: Image.asset(
                        AssetConstants.happyCloud,
                        scale: 1.75,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Image.asset(AssetConstants.title),
                        MyText(
                          '${context.translate.bestScore}: ${HighScores.highScores[0]}',
                          fontSize: 26,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyButton(
                                context.translate.play,
                                onPressed: () =>
                                    context.pushAndRemoveUntil(Routes.game),
                              ),
                              const SizedBox(height: 40),
                              MyButton(
                                context.translate.scores,
                                onPressed: () =>
                                    context.push(Routes.leaderboard),
                              ),
                              const SizedBox(height: 40),
                              MyButton(
                                context.translate.exit,
                                onPressed: () {
                                  exit(0);
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
