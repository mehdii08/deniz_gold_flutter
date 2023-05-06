import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScaffold extends StatefulWidget {
  final Widget child;

  const HomeScaffold({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            widget.child,
            const Align(
              alignment: Alignment.bottomCenter,
              child: AppBottomBar(),
            )
          ],
        ),
      );
}

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SafeArea(
        child: SizedBox(
          height: Dimens.bottomBarHeight,
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(height: Dimens.standard1, color: AppColors.nature.shade50),
                    Container(
                    height: Dimens.standard64,
                    color: AppColors.white,
                    child: Row(
                      children: [
                        BottomBarItem(
                          title: Strings.myAccount,
                          icon: SvgPicture.asset(
                            'assets/images/user_nav_liner.svg',
                            fit: BoxFit.fitWidth,
                            color: AppColors.nature.shade900,
                            width: Dimens.standard24,
                          ),
                        ),
                        const BottomBarItem(
                          title: Strings.trade,
                        ),
                        BottomBarItem(
                          title: Strings.home,
                          icon: SvgPicture.asset(
                            'assets/images/home_liner.svg',
                            fit: BoxFit.fitWidth,
                            color: AppColors.nature.shade900,
                            width: Dimens.standard24,
                          ),
                        ),
                      ],
                    ),
                  )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: Dimens.standard48,
                  height: Dimens.standard48,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.yellow,
                    border: Border.all(color: AppColors.yellow.shade600)
                  ),
                  child: SvgPicture.asset(
                    'assets/images/change_trade.svg',
                    fit: BoxFit.scaleDown,
                    color: AppColors.nature.shade900,
                    width: Dimens.standard24,
                    height: Dimens.standard24,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class BottomBarItem extends StatelessWidget {
  final Widget? icon;
  final String title;

  const BottomBarItem({
    Key? key,
    required this.title,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon!,
          if (icon == null) const SizedBox(height: Dimens.standard24),
          AppText(
            title,
            textStyle: AppTextStyle.button5,
            color: AppColors.nature.shade700,
          )
        ],
      ));
}
