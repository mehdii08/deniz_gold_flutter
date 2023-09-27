import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';

class UpdateDetailsDialog extends StatelessWidget {
  final List<String> description;
  final Function() onclick;

  const UpdateDetailsDialog({
    Key? key,
    required this.description,
    required this.onclick,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AlertDialog(
    contentPadding: const EdgeInsets.all(Dimens.standard16),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Strings.titleUpdateDetails,
          style: AppTextStyle.subTitle4.copyWith(color: AppColors.nature.shade900),
        ),
        const SizedBox(height: Dimens.standard2X),
        ...description
            .map((e) => Column(
          children: [
            Container(
              width: double.maxFinite,
              alignment: Alignment.centerRight,
              child: AppText(e,textStyle: AppTextStyle.body4,color: AppColors.nature.shade700,),
            ),
            const SizedBox(height: Dimens.standard8),
          ],
        ))
            .toList(),
        const SizedBox(height: Dimens.standard2X),
             AppButton(
              text: Strings.ok,
              onPressed: onclick,
               fullWidth: false,
            ),
        const SizedBox(height: Dimens.standard2X),
      ],
    ),
  );
}