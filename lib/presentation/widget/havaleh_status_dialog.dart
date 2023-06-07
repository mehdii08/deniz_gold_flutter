import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/data/dtos/havale_dto.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/pages/havale_screen.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HavalehStatusDialog extends StatelessWidget {
  final HavaleDTO havaleh;

  const HavalehStatusDialog({
    Key? key,
    required this.havaleh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Dimens.standard16))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Dimens.standard53,
              height: Dimens.standard53,
              padding: const EdgeInsets.all(Dimens.standard16),
              decoration: BoxDecoration(
                  color: havaleh.status == 2 ? AppColors.yellow : AppColors.red, shape: BoxShape.circle),
              child: SvgPicture.asset(
                havaleh.status == 2 ?
                'assets/images/done_check.svg' : 'assets/images/close.svg',
                width: Dimens.standard20,
                fit: BoxFit.fitWidth,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: Dimens.standard16),
            AppText(
              havaleh.status == 2 ? Strings.havalehConfirmed : Strings.havalehRejected,
              textStyle: AppTextStyle.subTitle3,
            ),
            const SizedBox(height: Dimens.standard24),
            HavalehItem(havaleh: havaleh),
            const SizedBox(height: Dimens.standard24),
            AppButton(
              text: Strings.understand,
              onPressed: () => context.pop(),
              color: AppColors.nature.shade50,
            ),
            const SizedBox(height: Dimens.standard24),
          ],
        ),
      );
}