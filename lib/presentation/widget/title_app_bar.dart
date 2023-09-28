import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/support_icon.dart';
import 'package:flutter/material.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

const toolbarHeight = 74.0;

class TitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  Function()? onClick;

  TitleAppBar({
    Key? key,
    required this.title,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      SafeArea(
        child: Container(
          color: AppColors.white,
          padding: const EdgeInsets.all(Dimens.standard16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SupportIcon(),
              if (onClick!=null) ...[
                const SizedBox(
                  width: Dimens.standard16,
                ),
                GestureDetector(
                  onTap: onClick,
                    child:
                    Container(
                        width: Dimens.standard40,
                        height: Dimens.standard40,
                        padding: const EdgeInsets.all(Dimens.standard8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Dimens.standard100),
                            border: Border.all(
                                width: Dimens.standard1,
                                color: AppColors.nature.shade100)),
                        child: SvgPicture.asset(
                          'assets/images/pdf.svg',
                          fit: BoxFit.cover,
                        )),
                )
              ],
              Expanded(
                  child: AppText(
                    title,
                    textStyle: AppTextStyle.subTitle3,
                    textAlign: TextAlign.right,
                  )),
              const SizedBox(width: Dimens.standard20),
              GestureDetector(
                onTap: () => context.pop(),
                child: SvgPicture.asset(
                  'assets/images/arrow_right.svg',
                  fit: BoxFit.none,
                  color: AppColors.nature.shade900,
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(toolbarHeight);
}
