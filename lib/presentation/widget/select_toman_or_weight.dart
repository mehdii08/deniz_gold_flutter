import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/data/enums.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:flutter/material.dart';

class SelectTomanOrWeight extends StatelessWidget {
  final TradeType selectedTradeType;
  final bool isToman;
  final VoidCallback onTomanPressed;
  final VoidCallback onWeightPressed;

  const SelectTomanOrWeight({
    Key? key,
    required this.selectedTradeType,
    required this.isToman,
    required this.onTomanPressed,
    required this.onWeightPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              children: [
                AppButton(
                  textColor: isToman ? AppColors.nature.shade900 : AppColors.nature.shade600,
                  text: selectedTradeType == TradeType.sell ? Strings.tomanBaseSell : Strings.tomanBaseBuy,
                  color: AppColors.transparent,
                  onPressed: onTomanPressed,
                ),
                Container(
                  width: double.infinity,
                  height: Dimens.standard2,
                  decoration: BoxDecoration(
                      color: isToman ? AppColors.nature.shade900 : AppColors.transparent,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimens.standard6))),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                AppButton(
                    color: AppColors.transparent,
                    textColor: isToman ? AppColors.nature.shade600 : AppColors.nature.shade900,
                    text: selectedTradeType == TradeType.sell ? Strings.weightBaseSell : Strings.weightBaseBuy,
                    onPressed: onWeightPressed),
                Container(
                  width: double.infinity,
                  height: Dimens.standard2,
                  decoration: BoxDecoration(
                      color: !isToman ? AppColors.nature.shade900 : AppColors.transparent,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimens.standard6))),
                )
              ],
            ),
          ),
        ],
      );
}
