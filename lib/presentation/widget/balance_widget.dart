import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/data/enums.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';

class BalanceWidget extends StatelessWidget {
  final String title;
  final String balance;
  final Widget icon;
  final IconAlign iconAlign;

  const BalanceWidget({
    Key? key,
    required this.title,
    required this.balance,
    required this.icon,
    required this.iconAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.standard10),
        child: Row(
          children: [
            Expanded(child: Container()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(title, textStyle: AppTextStyle.body5.copyWith(color: AppColors.nature.shade600)),
                AppText(balance, textStyle: AppTextStyle.button5.copyWith(color: AppColors.nature.shade800)),
              ],
            ),
            const SizedBox(width: Dimens.standard8),
            icon,
            const SizedBox(width: Dimens.standard8),
            SizedBox(
                height: Dimens.standard32,
                child: VerticalDivider(
                  color: AppColors.nature.shade50,
                  width: Dimens.standard2X,
                )),
          ],
        ),
      );
}
