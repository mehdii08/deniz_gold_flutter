import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/widget/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SupportIcon extends StatelessWidget {
  const SupportIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showSupportBottomSheet(context),
      child: Container(
        width: Dimens.standard40,
        height: Dimens.standard40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimens.standard100),
            border: Border.all(width: Dimens.standard1, color: AppColors.nature.shade100)),
        child: SvgPicture.asset(
          'assets/images/support.svg',
          fit: BoxFit.none,
        ),
      ),
    );
  }
}
