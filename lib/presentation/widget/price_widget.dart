import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/core/utils/extensions.dart';
import 'package:deniz_gold/data/dtos/home_price_dto.dart';
import 'package:deniz_gold/data/enums.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:deniz_gold/presentation/strings.dart';

class PriceWidget extends StatelessWidget {
  final String title;
  final HomePriceDTO homePrice;
  final bool isSell;
  final IconAlign changeArrowAlign;
  final Color? overrideTextColor;
  final Color? backgroundColor;

  const PriceWidget({
    Key? key,
    required this.title,
    required this.homePrice,
    required this.isSell,
    required this.changeArrowAlign,
    this.overrideTextColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final arrow = SizedBox(
    //   width: 15,
    //   child: Opacity(opacity: 0.2, child: ArrowWidget(changeType: changeType, color: overrideTextColor)),
    // );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimens.standard20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(Dimens.standard12)),
        color: isSell ? AppColors.red.shade600 : AppColors.green.shade600,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            title,
            textStyle: AppTextStyle.body5,
            color: AppColors.nature.shade50,
          ),
          const SizedBox(height: Dimens.standard4),
          AppText(
            homePrice.price.numberFormat(),
            textStyle: AppTextStyle.subTitle3,
            color: AppColors.nature.shade50,
          ),
          AppText(
            homePrice.unit,
            textStyle: AppTextStyle.body5,
            color: AppColors.nature.shade50,
          ),
          const SizedBox(height: Dimens.standard20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: Dimens.standard4),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.all(Radius.circular(Dimens.standard30))
            ),
            child: Center(
              child: AppText(
                isSell ? Strings.sellGold : Strings.buyGold,
                textStyle: AppTextStyle.button4,
                color: isSell ? AppColors.red.shade600 : AppColors.green.shade600,
              ),
            ),
          )
        ],
      ),
    );
  }

  Color getColor({required ChangeType changeType}) {
    return changeType == ChangeType.increased
        ? AppColors.green
        : changeType == ChangeType.decreased
            ? AppColors.red
            : AppColors.nature.shade900;
  }
}
