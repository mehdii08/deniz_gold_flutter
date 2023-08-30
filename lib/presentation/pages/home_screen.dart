import 'dart:async';

import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/core/utils/extensions.dart';
import 'package:deniz_gold/presentation/blocs/home/home_screen_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/pages/coin_shop_screen.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/UserAccountingChecker.dart';
import 'package:deniz_gold/presentation/widget/UserStatusChecker.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/buy_and_sell_prices.dart';
import 'package:deniz_gold/presentation/widget/confirm_dialog.dart';
import 'package:deniz_gold/presentation/widget/dual_balance_widget.dart';
import 'package:deniz_gold/presentation/widget/logo_app_bar.dart';
import 'package:deniz_gold/presentation/widget/permisson_checker.dart';
import 'package:deniz_gold/presentation/widget/prices_list.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  static final route = GoRoute(
    name: 'HomeScreen',
    path: '/home',
    builder: (_, __) => const HomeScreen(),
  );

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;
  late HomeScreenCubit homeScreenCubit;

  @override
  void initState() {
    homeScreenCubit = sl<HomeScreenCubit>()..getData();
    if (kIsWeb) {
      startTimer();
    }
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const period = Duration(seconds: 10);
    _timer = Timer.periodic(
      period,
      (Timer timer) {
        homeScreenCubit.getData(silent: true);
      },
    );
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: PermissionChecker(
          child: WillPopScope(
              onWillPop: () async {
                showDialog(
                  context: context,
                  builder: (context) => ConfirmDialog(
                    question: Strings.exitQuestion,
                    confirmTitle: Strings.exit,
                    cancelTitle: Strings.cancel,
                    onConfirmClicked: () {
                      SystemNavigator.pop();
                    },
                    onCancelClicked: () {
                      context.pop();
                    },
                  ),
                );
                return false;
              },
              child: UserStatusChecker(
                updateUser: true,
                child: Scaffold(
                  appBar: const LogoAppBar(),
                  backgroundColor: AppColors.background,
                  body: BlocProvider<HomeScreenCubit>.value(
                    value: homeScreenCubit,
                    child: BlocConsumer<HomeScreenCubit, HomeScreenState>(listener: (context, state) {
                      if (state is HomeScreenFailed) {
                        showToast(title: state.message, context: context, toastType: ToastType.error);
                      }
                    }, builder: (context, state) {
                      if (state is HomeScreenLoaded) {
                        final data = state.data;
                        return Column(
                          children: [
                            if (state.data.message != null && state.data.message?.isNotEmpty == true)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: Dimens.standard16, horizontal: Dimens.standard16),
                                decoration: BoxDecoration(
                                  color: AppColors.nature.shade50,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: AppText(
                                        state.data.message ?? '',
                                        textStyle: AppTextStyle.body5,
                                        color: AppColors.nature.shade700,
                                      ),
                                    ),
                                    const SizedBox(width: Dimens.standard8),
                                    SvgPicture.asset(
                                      'assets/images/info_fill.svg',
                                      fit: BoxFit.none,
                                    ),
                                  ],
                                ),
                              ),
                            Container(
                              color: AppColors.white,
                              padding: const EdgeInsets.symmetric(horizontal: Dimens.standard16),
                              child: Column(
                                children: [
                                  const UserAccountingChecker(
                                    updateUser: true,
                                    placeHolder: SizedBox(),
                                    child: DualBalanceWidget(),
                                  ),
                                  const SizedBox(height: Dimens.standard4),
                                  UserStatusChecker(
                                    checkTrade: true,
                                    placeHolder: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: Dimens.standard64),
                                        child: AppText(
                                            Strings.tradeIsBlocked,
                                            textStyle: AppTextStyle.subTitle3
                                        ),
                                      ),
                                    ),
                                    child: BuyAndSellPrices(
                                      buyPrice: data.buyPrice,
                                      sellPrice: data.sellPrice,
                                    ),
                                  ),
                                  const SizedBox(height: Dimens.standard16),
                                  UserStatusChecker(
                                    checkCoinTrade: true,
                                    placeHolder: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: Dimens.standard30),
                                        child: AppText(
                                            Strings.tradeIsBlocked,
                                            textStyle: AppTextStyle.subTitle3
                                        ),
                                      ),
                                    ),
                                    child: GestureDetector(
                                      onTap: () => context.goNamed(CoinShopScreen.route.name ?? ''),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: Dimens.standard24),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(Dimens.standard12),
                                          color: AppColors.background,
                                          border: Border.all(
                                            width: 2,
                                            color: AppColors.nature.shade100,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/arrow_left.svg',
                                                  width: Dimens.standard20,
                                                  fit: BoxFit.fitWidth,
                                                ),
                                                const SizedBox(
                                                  width: Dimens.standard8,
                                                ),
                                                AppText(
                                                  Strings.seeAll,
                                                  textStyle: AppTextStyle.body5,
                                                  color: AppColors.nature.shade700,
                                                ),
                                              ],
                                            ),
                                            Image.asset(
                                              'assets/images/coin.png',
                                              width: Dimens.standard48,
                                              fit: BoxFit.fitWidth,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                AppText(
                                                  '${state.data.coin?.name ?? ''} (${state.data.coin?.unit ?? ''})',
                                                  textStyle: AppTextStyle.body5,
                                                  color: AppColors.nature.shade700,
                                                ),
                                                AppText(
                                                  state.data.coin?.price.numberFormat() ?? '0',
                                                  textStyle: AppTextStyle.subTitle3,
                                                  color: AppColors.nature.shade900,
                                                  textDirection: TextDirection.ltr,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: Dimens.standard16),
                                ],
                              ),
                            ),
                            Divider(height: Dimens.standard1, color: AppColors.nature.shade50),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(Dimens.standard16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AppText(
                                        Strings.tradeCondition,
                                        textStyle: AppTextStyle.subTitle3,
                                      ),
                                      const SizedBox(height: Dimens.standard8),
                                      KeyValueWidget(
                                        title: Strings.goldOns,
                                        value: "${data.goldOns.price} ${data.goldOns.unit}",
                                      ),
                                      const SizedBox(height: Dimens.standard8),
                                      KeyValueWidget(
                                        title: Strings.goldGheramPrice,
                                        value:
                                            "${data.goldGheram.price.toString().numberFormat()} ${data.goldGheram.unit}",
                                      ),
                                      const SizedBox(height: Dimens.standard8),
                                      KeyValueWidget(
                                        title: Strings.worldGoldPrice,
                                        value:
                                            "${data.goldWorld.price.toString().numberFormat()} ${data.goldWorld.unit}",
                                      ),
                                      const SizedBox(height: Dimens.standard8),
                                      KeyValueWidget(
                                        title: Strings.weekMaxPrice,
                                        value:
                                            "${data.todayHighPrice.price.toString().numberFormat()} ${data.todayHighPrice.unit}",
                                      ),
                                      const SizedBox(height: Dimens.standard8),
                                      KeyValueWidget(
                                        title: Strings.weekMinPrice,
                                        value:
                                            "${data.todayLowPrice.price.toString().numberFormat()} ${data.todayLowPrice.unit}",
                                      ),
                                      const SizedBox(height: Dimens.standard20),
                                      AppText(
                                        Strings.priceChangesTitle,
                                        textStyle: AppTextStyle.subTitle3,
                                      ),
                                      const SizedBox(height: Dimens.standard12),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: AppText(
                                              Strings.buyPrice,
                                              textAlign: TextAlign.end,
                                              textStyle: AppTextStyle.body5.copyWith(color: AppColors.nature.shade600),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: AppText(
                                              Strings.sellPrice,
                                              textAlign: TextAlign.center,
                                              textStyle: AppTextStyle.body5.copyWith(color: AppColors.nature.shade600),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: AppText(
                                              Strings.time,
                                              textAlign: TextAlign.start,
                                              textStyle: AppTextStyle.body5.copyWith(color: AppColors.nature.shade600),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: Dimens.standard8),
                                      Divider(color: AppColors.nature.shade50),
                                      const SizedBox(height: Dimens.standard14),
                                      if (data.priceHistories != null) PricesList(prices: data.priceHistories!)
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
                  ),
                ),
              )),
        ),
      );
}

class KeyValueWidget extends StatelessWidget {
  final String title;
  final String value;

  const KeyValueWidget({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          AppText(
            value,
            textStyle: AppTextStyle.body4.copyWith(color: AppColors.nature.shade700),
          ),
          const Spacer(),
          AppText(
            title,
            textStyle: AppTextStyle.body4,
          ),
        ],
      );
}
