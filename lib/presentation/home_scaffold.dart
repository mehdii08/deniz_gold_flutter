import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/pages/coin_shop_screen.dart';
import 'package:deniz_gold/presentation/pages/home_screen.dart';
import 'package:deniz_gold/presentation/pages/profile_screen.dart';
import 'package:deniz_gold/presentation/pages/trade_screen.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/UserStatusChecker.dart';
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
  Widget build(BuildContext context) => UserStatusChecker(
    child: Scaffold(
          body: Stack(
            children: [
              widget.child,
              const Align(
                alignment: Alignment.bottomCenter,
                child: AppBottomBar(),
              )
            ],
          ),
        ),
  );
}

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouter.of(context).location;
    return SafeArea(
      child: SizedBox(
        height: Dimens.bottomBarHeight,
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
                    isSelected: currentRoute == ProfileScreen.route.path,
                    title: Strings.myAccount,
                    icon: SvgPicture.asset(
                      'assets/images/user_nav_liner.svg',
                      fit: BoxFit.fitWidth,
                      color: AppColors.nature.shade900,
                      width: Dimens.standard24,
                    ),
                    onTap: () => context.goNamed(ProfileScreen.route.name!),
                  ),
                  BottomBarItem(
                    isSelected: currentRoute == CoinShopScreen.route.path,
                    title: Strings.coinShop,
                    icon: SvgPicture.asset(
                      'assets/images/coins2.svg',
                      fit: BoxFit.fitWidth,
                      color: AppColors.nature.shade900,
                      width: Dimens.standard24,
                    ),
                    onTap: () => context.goNamed(CoinShopScreen.route.name!),
                  ),
                  BottomBarItem(
                    isSelected: currentRoute == TradeScreen.route.path,
                    title: Strings.goldShop,
                    icon: SvgPicture.asset(
                      'assets/images/change_trade.svg',
                      fit: BoxFit.fitWidth,
                      color: AppColors.nature.shade900,
                      width: Dimens.standard24,
                    ),
                    onTap: () => context.goNamed(TradeScreen.route.name!),
                  ),
                  BottomBarItem(
                    isSelected: currentRoute == HomeScreen.route.path,
                    title: Strings.home,
                    icon: SvgPicture.asset(
                      'assets/images/home_liner.svg',
                      fit: BoxFit.fitWidth,
                      color: AppColors.nature.shade900,
                      width: Dimens.standard24,
                    ),
                    onTap: () => context.goNamed(HomeScreen.route.name!),
                  ),
                ],
              ),
            )
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
  final VoidCallback onTap;

  const BottomBarItem({
    Key? key,
    required this.title,
    required this.onTap,
    this.icon,
    this.isSelected = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(
          child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.standard20, vertical: Dimens.standard4),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(Dimens.standard30)),
                      color: isSelected ? AppColors.yellow.shade100 : AppColors.transparent),
                  child: icon!),
            if (icon == null) const SizedBox(height: Dimens.standard24),
            AppText(
              title,
              textStyle: AppTextStyle.button5,
              color: AppColors.nature.shade700,
            )
          ],
        ),
      ));
}
