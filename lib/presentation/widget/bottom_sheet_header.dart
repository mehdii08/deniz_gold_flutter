import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class BottomSheetHeader extends StatelessWidget {
  final String title;
  final Widget child;

  const BottomSheetHeader({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom),
    child: SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Dimens.standard20),
          Row(
            children: [
              const SizedBox(width: Dimens.standard16),
              GestureDetector(
                onTap: () => context.pop(),
                child: SvgPicture.asset(
                  'assets/images/close.svg',
                  width: Dimens.standard32,
                  fit: BoxFit.fitWidth,
                ),
              ),
              const Spacer(),
              AppText(
                title,
                textStyle: AppTextStyle.subTitle3,
              ),
              const SizedBox(width: Dimens.standard16),
            ],
          ),
          const SizedBox(height: Dimens.standard20),
          Divider(color: AppColors.nature.shade50),
          child
        ],
      ),
    ),
  );
}