import 'package:flutter/material.dart';
import 'package:superbaby/constants/app_font_styles.dart';

class MyText extends StatelessWidget {
  final String text;
  final double? fontSize;

  const MyText(
    this.text, {
    super.key,
    this.fontSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.black,
        fontWeight: FontWeight.w800,
        fontFamily: AppFontStyles.daveysDoodleface,
      ),
    );
  }
}
