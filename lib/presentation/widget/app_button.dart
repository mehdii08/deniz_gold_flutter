import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final String? svgIcon;
  final bool isLoading;
  final bool fullWidth;
  final Color? color;
  final Color? textColor;
  final EdgeInsetsGeometry contentPadding;
  final TextStyle? textStyle;
  final double borderRadius;

  const AppButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.svgIcon,
    this.isLoading = false,
    this.fullWidth = true,
    this.contentPadding = const EdgeInsets.all(Dimens.standard10),
    this.textStyle,
    this.color,
    this.textColor,
    this.borderRadius = Dimens.standard100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        )),
        elevation: MaterialStateProperty.resolveWith<double>((Set<MaterialState> states) => Dimens.standard0),
        foregroundColor: MaterialStateProperty.all(AppColors.yellow),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return color != null ? color! : AppColors.yellow.shade400;
            } else if (states.contains(MaterialState.disabled)) {
              return color != null ? color!.withOpacity(0.4) : AppColors.yellow.shade200;
            }
            return isLoading
                ? color != null
                    ? color!
                    : AppColors.yellow.shade200
                : color != null
                    ? color!
                    : AppColors.yellow;
          },
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: contentPadding,
        child: Row(
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) const SizedBox(width: Dimens.standard32),
            AppText(
              text,
              textStyle: textStyle ?? AppTextStyle.body4,
              color: textColor ?? AppColors.nature.shade900,
            ),
            if (!isLoading && svgIcon != null) ...[
              const SizedBox(width: Dimens.standard8),
              SvgPicture.asset(
                svgIcon!,
                width: Dimens.standard24,
                fit: BoxFit.fitWidth,
                color: AppColors.nature.shade900,
              )
            ],
            if (isLoading) ...[
              const SizedBox(width: Dimens.standard8),
              SvgPicture.asset(
                'assets/images/loading.svg',
                width: Dimens.standard24,
                fit: BoxFit.fitWidth,
                color: AppColors.nature.shade900,
              )
            ]
          ],
        ),
      ),
    );
  }
}
