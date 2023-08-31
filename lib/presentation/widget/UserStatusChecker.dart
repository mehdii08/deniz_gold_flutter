import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/blocs/app_config/app_config_cubit.dart';
import 'package:deniz_gold/presentation/blocs/auth/authentication_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/pages/splash_screen.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:deniz_gold/presentation/widget/app_logo.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/logo_app_bar.dart';
import 'package:deniz_gold/presentation/widget/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserStatusChecker extends StatefulWidget {
  final Widget child;
  final bool updateUser;
  final bool checkTrade;
  final bool checkCoinTrade;
  final Widget? placeHolder;

  const UserStatusChecker({
    Key? key,
    required this.child,
    this.updateUser = false,
    this.checkTrade = false,
    this.checkCoinTrade = false,
    this.placeHolder,
  }) : super(key: key);

  @override
  State<UserStatusChecker> createState() => _UserStatusCheckerState();
}

class _UserStatusCheckerState extends State<UserStatusChecker> {
  @override
  Widget build(BuildContext context) {
    if (widget.updateUser) {
      context.read<AppConfigCubit>().getConfig();
    }
    return BlocConsumer<AppConfigCubit, AppConfigState>(
      listener: (context, state) {
        if (state.appConfig == null && context.read<AuthenticationCubit>().isAuthenticated) {
          context.read<AppConfigCubit>().getConfig();
        }
      },
      builder: (context, state) {
        if (state.appConfig == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state.appConfig?.user.statusCode != 0) {
          return widget.placeHolder ?? const DeActiveUserScreen();
        } else if ((widget.checkTrade && state.appConfig?.botStatus == "0") ||
            (widget.checkCoinTrade && state.appConfig?.coinStatus == "0")) {
          return IgnorePointer(
            ignoring: true,
            child: Stack(
              children: [
                Opacity(opacity: 0.4, child: widget.child),
                widget.placeHolder ?? const SizedBox(),
              ],
            ),
          );
        }
        return widget.child;
      },
    );
  }
}

class DeActiveUserScreen extends StatelessWidget {
  const DeActiveUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: const LogoAppBar(showLogo: false, backgroundColor: AppColors.transparent),
          body: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/images/splash_bg.png',
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.standard16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.standard32),
                  decoration: BoxDecoration(
                      color: AppColors.transparentWhite,
                      borderRadius: const BorderRadius.all(Radius.circular(Dimens.standard160))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppLogo(showTitle: false),
                      const SizedBox(height: Dimens.standard12),
                      AppText(
                        Strings.welcomeToDeniz,
                        textStyle: AppTextStyle.subTitle3,
                      ),
                      const SizedBox(height: Dimens.standard8),
                      AppText(
                        Strings.welcomeToDenizDescription,
                        textStyle: AppTextStyle.body4,
                        color: AppColors.nature.shade700,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Dimens.standard24),
                      AppButton(
                        text: Strings.callToSupport,
                        svgIcon: 'assets/images/support.svg',
                        onPressed: () => showSupportBottomSheet(context: context),
                      ),
                      const SizedBox(height: Dimens.standard24),
                      AppButton(
                        text: Strings.logout,
                        color: AppColors.nature.shade100,
                        svgIcon: 'assets/images/logout.svg',
                        onPressed: () {
                          context.read<AuthenticationCubit>().clearToken();
                          context.goNamed(SplashScreen.route.name!);
                        },
                      ),
                      const SizedBox(height: Dimens.standard160),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
