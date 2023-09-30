import 'package:deniz_gold/main.dart';
import 'package:deniz_gold/presentation/home_scaffold.dart';
import 'package:deniz_gold/presentation/pages/account_info_screen.dart';
import 'package:deniz_gold/presentation/pages/check_mobile_screen.dart';
import 'package:deniz_gold/presentation/pages/coin_shop_screen.dart';
import 'package:deniz_gold/presentation/pages/forget_password_screen.dart';
import 'package:deniz_gold/presentation/pages/havale_screen.dart';
import 'package:deniz_gold/presentation/pages/home_screen.dart';
import 'package:deniz_gold/presentation/pages/login_screen.dart';
import 'package:deniz_gold/presentation/pages/profile_screen.dart';
import 'package:deniz_gold/presentation/pages/register_screen.dart';
import 'package:deniz_gold/presentation/pages/reset_password_screen.dart';
import 'package:deniz_gold/presentation/pages/splash_screen.dart';
import 'package:deniz_gold/presentation/pages/trade_screen.dart';
import 'package:deniz_gold/presentation/pages/trades_screen.dart';
import 'package:deniz_gold/presentation/pages/transactions_screen.dart';
import 'package:deniz_gold/presentation/pages/verify_mobile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/receipt_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');

GoRouter buildRouter(BuildContext context) {
  return GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: rootNavigatorKey,
    initialLocation: SplashScreen.route.path,
    redirect: (_, state) {
      final location = state.location;
      final firstSection = location.contains("?") ? location.split("?")[0] : location;
      tradeWaitingDialogIsOnTop = firstSection == TradeScreen.route.path;
      return null;
    },
    routes: _routes,
  );
}

final _normalRoutes = [
  SplashScreen.route,
  CheckMobileScreen.route,
  RegisterScreen.route,
  LoginScreen.route,
  VerifyMobileScreen.route,
  ForgetPasswordScreen.route,
  ResetPasswordScreen.route,
];

final _authenticationGuardedRoutes = [
  //here is for authenticated pages without drawer
  // SomeScreen.route,
  ShellRoute(
    navigatorKey: homeNavigatorKey,
    builder: (context, state, child) {
      return HomeScaffold(
        child: child,
      );
    },
    routes: [
      HomeScreen.route,
      ReceiptScreen.route,
      TransactionsScreen.route,
      TradesScreen.route,
      ProfileScreen.route,
      AccountInfoScreen.route,
      CoinShopScreen.route,
      HavaleScreen.route,
      TradeScreen.route,
    ],
  )
];

final _routes = [..._normalRoutes, ..._authenticationGuardedRoutes];
