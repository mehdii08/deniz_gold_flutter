import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final bool showTitle;

  const AppLogo({
    Key? key,
    this.showTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.none,
        ),
        if (showTitle)
          AppText(
            Strings.appName,
            textStyle: AppTextStyle.subTitle3,
          )
      ],
    );
  }
}
