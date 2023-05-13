import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/data/enums.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:flutter/material.dart';

class TradeSwitchButton extends StatelessWidget {
  final TradeType selectedTradeType;
  final VoidCallback onSellPressed;
  final VoidCallback onBuyPressed;

  const TradeSwitchButton({
    Key? key,
    required this.selectedTradeType,
    required this.onBuyPressed,
    required this.onSellPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(Dimens.standard4),
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
            Radius.circular(Dimens.standard12)),
        border: Border.all(color: AppColors.nature.shade100)
    ),
    child: Row(
      children: [
        Expanded(
          child: AppButton(
            onPressed: onSellPressed,
            text: Strings.sell,
            color: selectedTradeType == TradeType.sell ? AppColors.red : AppColors.transparent,
            textColor: selectedTradeType == TradeType.sell ? AppColors.white : AppColors.nature.shade600,
            borderRadius: Dimens.standard12,
          ),
        ),
        const SizedBox(width: Dimens.standard4),
        Expanded(
          child: AppButton(
            onPressed: onBuyPressed,
            text: Strings.buy,
            color: selectedTradeType == TradeType.buy ? AppColors.green : AppColors.transparent,
            textColor: selectedTradeType == TradeType.buy ? AppColors.white : AppColors.nature.shade600,
            borderRadius: Dimens.standard12,
          ),
        )
      ],
    ),
  );
}
