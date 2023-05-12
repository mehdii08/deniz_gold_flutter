import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/presentation/blocs/splash/splash_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/pages/check_mobile_screen.dart';
import 'package:deniz_gold/presentation/pages/home_screen.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_logo.dart';
import 'package:deniz_gold/presentation/widget/confirm_dialog.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static final route = GoRoute(
    name: 'SplashScreen',
    path: '/splash',
    builder: (_, __) => SplashScreen(key: ValueKey(DateTime.now())),
  );

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<SplashCubit>(
        create: (_) => sl<SplashCubit>()..checkAuthentication(),
        child: BlocConsumer<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state is SplashAuthenticationChecked && state.authenticated) {
              context.read<SplashCubit>().getConfig();
            } else if (state is SplashAuthenticationChecked && !state.authenticated) {
              context.goNamed(CheckMobileScreen.route.name!);
            } else if (state is SplashLoaded) {
              context.goNamed(HomeScreen.route.name!);
            } else if (state is SplashFailed) {
              showToast(title: state.message, context: context, toastType: ToastType.error);
            } else if (state is SplashUpdateNeeded) {
              final dialog = ConfirmDialog(
                question: Strings.updateDescription,
                confirmTitle: Strings.update,
                cancelTitle: Strings.later,
                onConfirmClicked: () async {
                  context.pop();
                  if (await canLaunchUrlString(state.appVersion.link)) {
                    await launchUrlString(state.appVersion.link, mode: LaunchMode.externalApplication);
                  }
                },
                onCancelClicked: state.appVersion.forceUpdate ? null : () => context.goNamed(HomeScreen.route.name!),
              );

              showDialog(context: context, builder: (context) => dialog);
            }
          },
          builder: (context, state) => Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                    'assets/images/splash_bg.png',
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimens.standard125, horizontal: Dimens.standard16),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(Radius.circular(Dimens.standard160))
                  ),
                  child: const Center(
                    child: AppLogo(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
