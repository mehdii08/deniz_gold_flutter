import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyView extends StatelessWidget {
  final String text;
  final String buttonText;
  final String? svgIcon;
  final Color? buttonColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const EmptyView({
    Key? key,
    required this.text,
    this.buttonText = "",
    this.svgIcon,
    this.buttonColor,
    this.textColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/paper.svg'),
            const SizedBox(height: Dimens.standard12),
            AppText(
              text,
              textStyle: AppTextStyle.body5,
              color: AppColors.nature.shade600,
            ),
            const SizedBox(height: Dimens.standard16),
            if (onTap != null)
              AppButton(
                text: buttonText,
                fullWidth: false,
                textColor: textColor ?? AppColors.nature.shade900,
                textStyle: AppTextStyle.button5,
                color: buttonColor ?? AppColors.yellow,
                contentPadding: const EdgeInsets.symmetric(horizontal: Dimens.standard16, vertical: Dimens.standard4),
                onPressed: onTap,
              )
          ],
        ),
      );
}
