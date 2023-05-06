import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';

class ConfirmDialog extends StatelessWidget {
  final String question;
  final String confirmTitle;
  final String cancelTitle;
  final VoidCallback onConfirmClicked;
  final VoidCallback? onCancelClicked;

  const ConfirmDialog({
    Key? key,
    required this.question,
    required this.confirmTitle,
    this.cancelTitle = Strings.cancel,
    required this.onConfirmClicked,
    this.onCancelClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          question,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.nature.shade900),
        ),
        const SizedBox(height: Dimens.standard2X),
        Row(
          children: [
            if(onCancelClicked != null)
              ...[
                Expanded(
                    child: AppButton(
                        text: cancelTitle,
                        onPressed: onCancelClicked)),
                const SizedBox(width: Dimens.standardX),
              ],
            Expanded(
                child: AppButton(
                  text: confirmTitle,
                  onPressed: onConfirmClicked,
                ))
          ],
        )
      ],
    ),
  );
}