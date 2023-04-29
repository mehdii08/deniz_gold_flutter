import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;

  const AppButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.standard100),
        )),
        elevation: MaterialStateProperty.resolveWith<double>(
            (Set<MaterialState> states) => Dimens.standard0),
        foregroundColor: MaterialStateProperty.all(AppColors.yellow),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return AppColors.yellow.shade400;
            } else if (states.contains(MaterialState.disabled)) {
              return AppColors.yellow.shade200;
            }
            return isLoading ? AppColors.yellow.shade200 : AppColors.yellow;
          },
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.standard10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) const SizedBox(width: Dimens.standard32),
            AppText(
              text,
              textStyle: AppTextStyle.body4,
              color: AppColors.nature.shade900,
            ),
            if (isLoading) ...[
              const SizedBox(width: Dimens.standard8),
              SvgPicture.asset(
                'assets/images/loading.svg',
                fit: BoxFit.none,
                color: AppColors.nature.shade900,
              )
            ]
          ],
        ),
      ),
    );
  }
}
