import 'package:deniz_gold/presentation/blocs/app_config/app_config_cubit.dart';
import 'package:deniz_gold/presentation/blocs/auth/authentication_cubit.dart';
import 'package:deniz_gold/presentation/navigation/app_router.dart';
import 'package:deniz_gold/presentation/pages/splash_screen.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final appKey = GlobalKey();

class DenizApp extends StatelessWidget {
  const DenizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationCubit>(
            create: (_) => sl<AuthenticationCubit>(),
          ),
          BlocProvider<AppConfigCubit>(
            create: (_) => sl<AppConfigCubit>()..getConfig(),
          ),
          ChangeNotifierProvider<GoRouter>(create: buildRouter),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<AppConfigCubit, AppConfigState>(
              listener: (context, state) {
                if (state.appConfig != null && state.appConfig!.user.statusCode == 2) {
                  context.read<AuthenticationCubit>().logOut();
                  context.goNamed(SplashScreen.route.name!);
                }
              },
            ),
            BlocListener<AuthenticationCubit, AuthenticationState?>(
              listener: (context, state) {
                if(state is UnAuthenticated){
                  context.read<GoRouter>().goNamed(SplashScreen.route.name!);
                }
              },
            ),
          ],
          child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
            builder: (context, state) {
              context.read<AuthenticationCubit>().storeFCMToken();
              return MaterialApp.router(
                key: appKey,
                routerConfig: context.read<GoRouter>(),
                theme: appTheme,
              );
            },
          ),
        ),
      );
}

final appTheme = ThemeData(
  fontFamily: 'AppFont',
);
