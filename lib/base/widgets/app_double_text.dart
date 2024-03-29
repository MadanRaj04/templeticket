import 'package:flutter/material.dart';
import 'package:templeticketsystem/base/res/styles/app_styles.dart';
import 'package:templeticketsystem/base/utils/app_routes.dart';
import 'package:templeticketsystem/screens/home/all_tickets.dart';

class AppDoubleText extends StatelessWidget {
  const AppDoubleText(
      {Key? key,
      required this.bigText,
      required this.smallText,
      required this.func})
      : super(key: key);
  final String bigText;
  final String smallText;
  final VoidCallback func;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(bigText, style: AppStyles.headLineStyle2),
      InkWell(
          onTap: func,
          child: Text(smallText,
              style:
                  AppStyles.textStyle.copyWith(color: AppStyles.primaryColor)))
    ]);
  }
}
