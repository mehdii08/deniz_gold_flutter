import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/support_icon.dart';
import 'package:flutter/material.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

const toolbarHeight = 74.0;

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: AppColors.white,
        padding: const EdgeInsets.all(Dimens.standard16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SupportIcon(),
            Expanded(
                child: AppText(
              Strings.verifyMobileTitle,
              textStyle: AppTextStyle.subTitle3,
                  textAlign: TextAlign.right,
            )),
            const SizedBox(width: Dimens.standard20),
            GestureDetector(
              onTap: ()=> context.pop(),
              child: SvgPicture.asset(
                'assets/images/arrow_right.svg',
                fit: BoxFit.none,
                color: AppColors.nature.shade900,
              ),
            ),
          ],
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(toolbarHeight);
}
