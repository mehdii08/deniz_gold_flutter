import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/pages/home_screen.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

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
  Widget build(BuildContext context) {
    final currentRoute = GoRouter.of(context).location;
    final tradeIsSelected = currentRoute == '/trade';//todo replace with TradeScreen.route.path
    return SafeArea(
      child: SizedBox(
        height: Dimens.bottomBarHeight + (tradeIsSelected ? 3 : 0),
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
                          isSelected : currentRoute == '/profile',//todo replace with ProfileScreen.route.path
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
                          isSelected : currentRoute == HomeScreen.route.path,
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
                width: tradeIsSelected ? Dimens.standard53 : Dimens.standard48,
                height: tradeIsSelected ? Dimens.standard53 : Dimens.standard48,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.yellow,
                    border: Border.all(
                        color: tradeIsSelected ? AppColors.yellow.shade100 : AppColors.yellow.shade600,
                      width: tradeIsSelected ? Dimens.standard6 : Dimens.standard1,
                    )),
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
}

class BottomBarItem extends StatelessWidget {
  final Widget? icon;
  final String title;
  final bool isSelected;

  const BottomBarItem({
    Key? key,
    required this.title,
    this.icon,
    this.isSelected = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.standard20, vertical: Dimens.standard4),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(Dimens.standard30)),
              color: isSelected ? AppColors.yellow.shade100 : AppColors.transparent
            ),
              child: icon!
          ),
          if (icon == null) const SizedBox(height: Dimens.standard24),
          AppText(
            title,
            textStyle: AppTextStyle.button5,
            color: AppColors.nature.shade700,
          )
        ],
      ));
}
