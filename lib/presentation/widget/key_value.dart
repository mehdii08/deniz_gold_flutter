import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';

class KeyValue extends StatelessWidget {
  final String title;
  final String value;

  const KeyValue({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    children: [
      AppText(
        value,
        textStyle: AppTextStyle.body4,
        color: AppColors.nature.shade900,
      ),
      const Spacer(),
      AppText(
        title,
        textStyle: AppTextStyle.body4,
        color: AppColors.nature.shade700,
      ),
    ],
  );
}