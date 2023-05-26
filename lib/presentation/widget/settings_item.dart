import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsItem extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  final bool showArrow;

  const SettingsItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.showArrow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Row(
      children: [
        if (showArrow)
          SvgPicture.asset(
            'assets/images/left.svg',
            width: Dimens.standard24,
            fit: BoxFit.fitWidth,
          ),
        const Spacer(),
        AppText(
          title,
          textStyle: AppTextStyle.button4,
          color: AppColors.nature.shade800,
        ),
        const SizedBox(
          width: Dimens.standard12,
        ),
        Container(
          width: Dimens.standard40,
          height: Dimens.standard40,
          padding: const EdgeInsets.all(Dimens.standard8),
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: AppColors.white, border: Border.all(color: AppColors.nature.shade50)),
          child: SvgPicture.asset(
            icon,
            color: AppColors.nature.shade800,
          ),
        ),
      ],
    ),
  );
}