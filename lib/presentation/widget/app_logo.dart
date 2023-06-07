import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final bool showTitle;
  final double logoWidth;

  const AppLogo({
    Key? key,
    this.showTitle = true,
    this.logoWidth = Dimens.standard130,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: logoWidth,
          fit: BoxFit.fitWidth,
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
