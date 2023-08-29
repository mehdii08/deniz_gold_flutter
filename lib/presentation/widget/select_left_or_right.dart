import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:flutter/material.dart';

class SelectLeftOrRight extends StatelessWidget {
  final bool isLeftSelected;
  final VoidCallback onLeftPressed;
  final VoidCallback onRightPressed;
  final String rightTitle;
  final String leftTitle;
  final Color backgroundColor;

  const SelectLeftOrRight({
    Key? key,
    required this.isLeftSelected,
    required this.onLeftPressed,
    required this.onRightPressed,
    required this.leftTitle,
    required this.rightTitle,
    this.backgroundColor = AppColors.background,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: backgroundColor,
    child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                children: [
                  AppButton(
                    textColor: isLeftSelected ? AppColors.nature.shade900 : AppColors.nature.shade600,
                    text: leftTitle,
                    color: AppColors.transparent,
                    onPressed: onLeftPressed,
                  ),
                  Container(
                    width: double.infinity,
                    height: Dimens.standard2,
                    decoration: BoxDecoration(
                        color: isLeftSelected ? AppColors.nature.shade900 : AppColors.transparent,
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
                      textColor: isLeftSelected ? AppColors.nature.shade600 : AppColors.nature.shade900,
                      text: rightTitle,
                      onPressed: onRightPressed),
                  Container(
                    width: double.infinity,
                    height: Dimens.standard2,
                    decoration: BoxDecoration(
                        color: !isLeftSelected ? AppColors.nature.shade900 : AppColors.transparent,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimens.standard6))),
                  )
                ],
              ),
            ),
          ],
        ),
  );
}
