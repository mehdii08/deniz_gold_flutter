import 'package:deniz_gold/presentation/home_scaffold.dart';
import 'package:deniz_gold/presentation/pages/home_screen.dart';
import 'package:deniz_gold/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');

GoRouter buildRouter(BuildContext context) {
  return GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: rootNavigatorKey,
    initialLocation: SplashScreen.route.path,
    redirect: (_, state){
      return null;
    },
    routes: _routes,
  );
}

final _normalRoutes = [
  SplashScreen.route,
  // CheckMobileScreen.route,
  // RegisterScreen.route,
  // LoginScreen.route,
  // ForgetPasswordScreen.route,
  // ResetPasswordScreen.route,
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
      // TransactionsScreen.route,
      // TradesScreen.route,
      // ProfileScreen.route,
      // ChangePasswordScreen.route,
      // UpdateProfileScreen.route,
      // HavaleScreen.route,
      // TradeScreen.route,
    ],
  )
];

final _routes = [..._normalRoutes, ..._authenticationGuardedRoutes];
