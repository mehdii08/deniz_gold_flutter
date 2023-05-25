import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/core/utils/extensions.dart';
import 'package:deniz_gold/presentation/blocs/app_config/app_config_cubit.dart';
import 'package:deniz_gold/presentation/blocs/auth/authentication_cubit.dart';
import 'package:deniz_gold/presentation/blocs/balance/balance_cubit.dart';
import 'package:deniz_gold/presentation/blocs/profile/profile_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/pages/account_info_screen.dart';
import 'package:deniz_gold/presentation/pages/havale_screen.dart';
import 'package:deniz_gold/presentation/pages/home_screen.dart';
import 'package:deniz_gold/presentation/pages/splash_screen.dart';
import 'package:deniz_gold/presentation/pages/trades_screen.dart';
import 'package:deniz_gold/presentation/pages/transactions_screen.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/UserAccountingChecker.dart';
import 'package:deniz_gold/presentation/widget/UserStatusChecker.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/logo_app_bar.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';
import 'package:deniz_gold/presentation/widget/utils.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static final route = GoRoute(
    name: 'ProfileScreen',
    path: '/profile',
    builder: (_, __) => const ProfileScreen(),
  );

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) => UserStatusChecker(
        child: SafeArea(
          child: WillPopScope(
            onWillPop: () async {
              context.goNamed(HomeScreen.route.name!);
              return false;
            },
            child: Scaffold(
              backgroundColor: AppColors.white,
              appBar: const LogoAppBar(),
              body: BlocProvider<ProfileCubit>(
                create: (_) => sl<ProfileCubit>()..updateData(),
                child: BlocConsumer<ProfileCubit, ProfileState>(
                  listener: (context, state) {
                    if (state is ProfileFailed) {
                      showToast(title: state.message, context: context, toastType: ToastType.error);
                    }
                  },
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: Dimens.standard8),
                          SvgPicture.asset(
                            'assets/images/avatar.svg',
                            width: Dimens.standard64,
                            fit: BoxFit.fitWidth,
                          ),
                          const SizedBox(height: Dimens.standard16),
                          if (state is ProfileSuccess) ...[
                            AppText(
                              state.appConfig.user.name,
                              textStyle: AppTextStyle.subTitle4,
                            ),
                            AppText(
                              state.appConfig.user.mobile,
                              textStyle: AppTextStyle.body5,
                              color: AppColors.nature.shade600,
                            ),
                            const SizedBox(height: Dimens.standard4),
                            const UserAccountingChecker(
                              updateUser: true,
                              placeHolder: DualBalanceWidget(),
                              child: DualBalanceWidget(),
                            ),
                          ],
                          const SizedBox(height: Dimens.standard16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(Dimens.standard16),
                            decoration: const BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.standard16))),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: AppText(
                                    Strings.account,
                                    textStyle: AppTextStyle.subTitle3,
                                    color: AppColors.nature.shade600,
                                  ),
                                ),
                                const SizedBox(height: Dimens.standard12),
                                SettingsItem(
                                  icon: "assets/images/task_list.svg",
                                  title: Strings.storeGoldenHavale,
                                  onTap: () => context.pushNamed(HavaleScreen.route.name!),
                                ),
                                const SizedBox(height: Dimens.standard16),
                                SettingsItem(
                                  icon: "assets/images/change_trade.svg",
                                  title: Strings.myTrades,
                                  onTap: () => context.pushNamed(TradesScreen.route.name!),
                                ),
                                const SizedBox(height: Dimens.standard16),
                                SettingsItem(
                                  icon: "assets/images/repeat_rotate.svg",
                                  title: Strings.transactions,
                                  onTap: () => context.pushNamed(TransactionsScreen.route.name!),
                                ),
                                const SizedBox(height: Dimens.standard24),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: AppText(
                                    Strings.settings,
                                    textStyle: AppTextStyle.subTitle3,
                                    color: AppColors.nature.shade600,
                                  ),
                                ),
                                const SizedBox(height: Dimens.standard12),
                                SettingsItem(
                                  icon: "assets/images/user_nav_liner.svg",
                                  title: Strings.accountInfo,
                                  onTap: () => context.pushNamed(AccountInfoScreen.route.name!),
                                ),
                                const SizedBox(height: Dimens.standard16),
                                SettingsItem(
                                  icon: "assets/images/key.svg",
                                  title: Strings.changePassword,
                                  onTap: () => showPasswordEditBottomSheet(context: context),
                                ),
                                const SizedBox(height: Dimens.standard16),
                                const Divider(
                                  endIndent: Dimens.standard54,
                                  color: AppColors.white,
                                  thickness: Dimens.standard2,
                                ),
                                const SizedBox(height: Dimens.standard16),
                                SettingsItem(
                                  icon: "assets/images/logout.svg",
                                  title: Strings.logout,
                                  onTap: () {
                                    context.read<AppConfigCubit>().reset();
                                    context.read<AuthenticationCubit>().logOut();
                                    context.pushNamed(SplashScreen.route.name!);
                                  },
                                  showArrow: false,
                                ),
                                const SizedBox(height: Dimens.standard100),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
}

class SettingsItem extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  final bool showArrow;

  const SettingsItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.showArrow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            if (showArrow)
              SvgPicture.asset(
                'assets/images/left.svg',
                width: Dimens.standard24,
                fit: BoxFit.fitWidth,
              ),
            const Spacer(),
            AppText(
              title,
              textStyle: AppTextStyle.button4,
              color: AppColors.nature.shade800,
            ),
            const SizedBox(
              width: Dimens.standard12,
            ),
            Container(
              width: Dimens.standard40,
              height: Dimens.standard40,
              padding: const EdgeInsets.all(Dimens.standard8),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: AppColors.white, border: Border.all(color: AppColors.nature.shade50)),
              child: SvgPicture.asset(
                icon,
                color: AppColors.nature.shade800,
              ),
            ),
          ],
        ),
      );
}

class DualBalanceWidget extends StatefulWidget {
  const DualBalanceWidget({Key? key}) : super(key: key);

  @override
  State<DualBalanceWidget> createState() => _DualBalanceWidgetState();
}

class _DualBalanceWidgetState extends State<DualBalanceWidget> {
  @override
  Widget build(BuildContext context) => BlocProvider<BalanceCubit>(
        create: (_) => sl(),
        child: Container(
          decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.all(Radius.circular(8))),
          padding: const EdgeInsets.all(8),
          child: BlocBuilder<BalanceCubit, BalanceState>(
            builder: (context, balanceState) => SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          Strings.remainingGold,
                          textStyle: AppTextStyle.body5,
                          color: AppColors.nature.shade600,
                        ),
                        AppText(
                            balanceState is BalanceLoaded
                                ? balanceState.data.goldBalance.numberFormat()
                                : Strings.stars,
                          textStyle: AppTextStyle.body4,
                          color: AppColors.nature.shade800,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: balanceState is BalanceLoading
                        ? const SizedBox(width: 30, height: 30, child: CircularProgressIndicator())
                        : GestureDetector(
                            onTap: () => balanceState is BalanceInitial
                                ? context.read<BalanceCubit>().getData()
                                : context.read<BalanceCubit>().reset(),
                            child: Image.asset(
                              balanceState is BalanceInitial ? "assets/images/eye.png" : "assets/images/eye_slash.png",
                              width: 20,
                              height: 20,
                              color: AppColors.nature.shade700,
                            ),
                          ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          Strings.remainingRials,
                          textStyle: AppTextStyle.body5,
                          color: AppColors.nature.shade600,
                        ),
                        AppText(
                            balanceState is BalanceLoaded
                                ? balanceState.data.rialBalance.numberFormat()
                                : Strings.stars,
                          textStyle: AppTextStyle.body4,
                          color: AppColors.nature.shade800,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
