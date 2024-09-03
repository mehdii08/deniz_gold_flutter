import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/blocs/app_config/app_config_cubit.dart';
import 'package:deniz_gold/presentation/blocs/auth/authentication_cubit.dart';
import 'package:deniz_gold/presentation/blocs/profile/profile_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/pages/account_info_screen.dart';
import 'package:deniz_gold/presentation/pages/havale_screen.dart';
import 'package:deniz_gold/presentation/pages/home_screen.dart';
import 'package:deniz_gold/presentation/pages/receipt_screen.dart';
import 'package:deniz_gold/presentation/pages/splash_screen.dart';
import 'package:deniz_gold/presentation/pages/trades_screen.dart';
import 'package:deniz_gold/presentation/pages/transactions_screen.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/UserAccountingChecker.dart';
import 'package:deniz_gold/presentation/widget/UserStatusChecker.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/confirm_dialog.dart';
import 'package:deniz_gold/presentation/widget/dual_balance_widget.dart';
import 'package:deniz_gold/presentation/widget/logo_app_bar.dart';
import 'package:deniz_gold/presentation/widget/settings_item.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';
import 'package:deniz_gold/presentation/widget/utils.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
  late PackageInfo packageInfo;

  @override
  void initState() {
    packageInfo = context.read<PackageInfo>();
    super.initState();
  }

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
              appBar: const LogoAppBar(showMenu: false,),
              body: BlocProvider<ProfileCubit>(
                create: (_) => sl<ProfileCubit>()..updateData(),
                child: BlocListener<AppConfigCubit, AppConfigState>(
                  listener: (context, state) {
                    if (state is AppConfigLoaded) {
                      context.read<ProfileCubit>().updateData();
                    }
                  },
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
                              height: Dimens.standard64,
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
                                placeHolder: SizedBox(),
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
                                  const SizedBox(height: Dimens.standard16),
                                  SettingsItem(
                                    icon: "assets/images/check_in_board.svg",
                                    title: Strings.receipt,
                                    onTap: () => context.pushNamed(ReceiptScreen.route.name!),
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
                                      final dialog = ConfirmDialog(
                                        question: Strings.exitQuestion,
                                        confirmTitle: Strings.exit,
                                        cancelTitle: Strings.cancel,
                                        onConfirmClicked: () async {
                                          context.read<AppConfigCubit>().reset();
                                          context.read<AuthenticationCubit>().logOut();
                                          context.pushNamed(SplashScreen.route.name!);
                                        },
                                        onCancelClicked: context.pop,
                                      );

                                      showDialog(context: context, builder: (context) => dialog);
                                    },
                                    showArrow: false,
                                  ),
                                  const SizedBox(height: Dimens.standard40),
                                  AppText(
                                    '${packageInfo.version} (${packageInfo.buildNumber})',
                                    textStyle: AppTextStyle.body5,
                                    color: AppColors.nature.shade300,
                                    textDirection: TextDirection.ltr,
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
        ),
      );
}
