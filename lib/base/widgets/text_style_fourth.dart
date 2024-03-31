import 'package:flutter/material.dart';
import 'package:templeticketsystem/base/res/styles/app_styles.dart';

class TextStyleFourth extends StatelessWidget {
  final String text;
  final bool? isColor;

  const TextStyleFourth(
      {super.key,
      required this.text,
      this.isColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: isColor == null
          ? AppStyles.headLineStyle4.copyWith(color: Colors.white)
          : AppStyles.headLineStyle4,
    );
  }
}
