import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Dimens.standard16))),
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
            .map((e) => UpdateDetailWidget(title: e))
            .toList(),
        const SizedBox(height: Dimens.standard2X),
             AppButton(
              text: Strings.understand,
              onPressed: onclick,
               fullWidth: false,
            ),
        const SizedBox(height: Dimens.standard2X),
      ],
    ),
  );
}

class UpdateDetailWidget extends StatelessWidget {
  final String title;
  const UpdateDetailWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: AppText(title,textStyle: AppTextStyle.body4,color: AppColors.nature.shade700,)),
      const SizedBox(width: Dimens.standard8),
      Padding(
        padding: const EdgeInsets.only(top: Dimens.standard4),
        child: SvgPicture.asset('assets/images/checkmark_circle.svg'),
      )
    ],
  );
}
