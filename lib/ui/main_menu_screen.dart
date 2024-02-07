import 'dart:io';

import 'package:flutter/material.dart';
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
                image: AssetImage('assets/ui/background.png'),
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
                        'assets/ui/heroJump.png',
                        scale: 1.25,
                      ),
                    ),
                    Positioned(
                      bottom: constrains.maxHeight * .60,
                      child: Image.asset(
                        'assets/ui/LandPiece_DarkMulticolored.png',
                        scale: 1.25,
                      ),
                    ),
                    Positioned(
                      bottom: constrains.maxHeight * .05,
                      left: constrains.maxWidth * .2,
                      child: Image.asset(
                        'assets/ui/BrokenLandPiece_Beige.png',
                        scale: 1.25,
                      ),
                    ),
                    Positioned(
                      bottom: constrains.maxHeight * .3,
                      right: 0,
                      child: Image.asset(
                        'assets/ui/LandPiece_DarkBlue.png',
                        scale: 1.5,
                      ),
                    ),
                    Positioned(
                      top: constrains.maxHeight * .3,
                      right: 0,
                      child: Image.asset(
                        'assets/ui/HappyCloud.png',
                        scale: 1.75,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Image.asset('assets/ui/title.png'),
                        MyText(
                          'En Yüksek Skor: ${HighScores.highScores[0]}',
                          fontSize: 26,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyButton(
                                'Oyna',
                                onPressed: () =>
                                    context.pushAndRemoveUntil(Routes.game),
                              ),
                              const SizedBox(height: 40),
                              MyButton(
                                'Skorlar',
                                onPressed: () =>
                                    context.push(Routes.leaderboard),
                              ),
                              const SizedBox(height: 40),
                              MyButton(
                                'Çıkıs',
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
