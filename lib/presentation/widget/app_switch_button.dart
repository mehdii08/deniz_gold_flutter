import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:flutter/material.dart';

class AppSwitchButton extends StatelessWidget {
  final SwitchSide selectedSide;
  final VoidCallback onLeftPressed;
  final VoidCallback onRightPressed;
  final String leftTitle;
  final String rightTitle;

  const AppSwitchButton({
    Key? key,
    required this.selectedSide,
    required this.onRightPressed,
    required this.onLeftPressed,
    this.leftTitle = Strings.sellGold,
    this.rightTitle = Strings.buyGold,
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
            onPressed: onLeftPressed,
            text: leftTitle,
            color: selectedSide == SwitchSide.left ? AppColors.red : AppColors.transparent,
            textColor: selectedSide == SwitchSide.left ? AppColors.white : AppColors.nature.shade600,
            borderRadius: Dimens.standard12,
          ),
        ),
        const SizedBox(width: Dimens.standard4),
        Expanded(
          child: AppButton(
            onPressed: onRightPressed,
            text: rightTitle,
            color: selectedSide == SwitchSide.right ? AppColors.green : AppColors.transparent,
            textColor: selectedSide == SwitchSide.right ? AppColors.white : AppColors.nature.shade600,
            borderRadius: Dimens.standard12,
          ),
        )
      ],
    ),
  );
}

enum SwitchSide{
  left,
  right
}
