import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color? color;

  const AppText(
    this.text, {
    Key? key,
    this.textStyle,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: textStyle?.copyWith(color: color) ??
            AppTextStyle.body1.copyWith(color: color),
      );
}
