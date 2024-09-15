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
import 'package:go_router/go_router.dart';

import '../../data/dtos/trade_info_dto.dart';
import '../../data/enums.dart';
import '../widget/utils.dart';

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
                  backgroundColor: AppColors.white,
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
                            const TopRadius(),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 12),
                                    if (state.data.message != null && state.data.message?.isNotEmpty == true)
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 8),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: Dimens.standard12, horizontal: Dimens.standard12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffD4E4FA),
                                          borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: AppText(
                                          state.data.message ?? '',
                                          textStyle: AppTextStyle.body5,
                                          color: AppColors.nature.shade700,
                                        ),
                                      ),
                                    Container(
                                      color: AppColors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: Dimens.standard8),
                                      child: Column(
                                        children: [
                                          const UserAccountingChecker(
                                            updateUser: true,
                                            placeHolder: SizedBox(),
                                            child: DualBalanceWidget(),
                                          ),
                                          const SizedBox(height: Dimens.standard4),
                                          if(state.data.trades.isNotEmpty)
                                            HomeTradesWidget(
                                              trades: state.data.trades,
                                              onTradeTap: (tradeInfo, buyAndSellType) {
                                                showTradeBottomSheet(
                                                    context: context,
                                                    tradeInfo: tradeInfo,
                                                    buyAndSellType: buyAndSellType,
                                                    homeCubit: homeScreenCubit
                                                );
                                              },
                                            ),
                                          if(state.data.coins.isNotEmpty)
                                            ...[
                                              const SizedBox(height: 8),
                                              HomeTradesWidget(
                                                trades: state.data.coins,
                                                onTradeTap: (tradeInfo, buyAndSellType) {
                                                  showTradeBottomSheet(
                                                      context: context,
                                                      tradeInfo: tradeInfo,
                                                      buyAndSellType: buyAndSellType,
                                                      homeCubit: homeScreenCubit
                                                  );
                                                },
                                              ),
                                            ],
                                          const SizedBox(height: Dimens.standard16),
                                        ],
                                      ),
                                    ),
                                    Divider(height: Dimens.standard1, color: AppColors.nature.shade50),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(Dimens.standard16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          // AppText(
                                          //   Strings.tradeCondition,
                                          //   textStyle: AppTextStyle.subTitle3,
                                          // ),
                                          // const SizedBox(height: Dimens.standard8),
                                          // KeyValueWidget(
                                          //   title: Strings.goldOns,
                                          //   value: "${data.goldOns.price} ${data.goldOns.unit}",
                                          // ),
                                          // const SizedBox(height: Dimens.standard8),
                                          // KeyValueWidget(
                                          //   title: Strings.goldGheramPrice,
                                          //   value:
                                          //       "${data.goldGheram.price.toString().numberFormat()} ${data.goldGheram.unit}",
                                          // ),
                                          // const SizedBox(height: Dimens.standard8),
                                          // KeyValueWidget(
                                          //   title: Strings.worldGoldPrice,
                                          //   value:
                                          //       "${data.goldWorld.price.toString().numberFormat()} ${data.goldWorld.unit}",
                                          // ),
                                          // const SizedBox(height: Dimens.standard8),
                                          // KeyValueWidget(
                                          //   title: Strings.weekMaxPrice,
                                          //   value:
                                          //       "${data.todayHighPrice.price.toString().numberFormat()} ${data.todayHighPrice.unit}",
                                          // ),
                                          // const SizedBox(height: Dimens.standard8),
                                          // KeyValueWidget(
                                          //   title: Strings.weekMinPrice,
                                          //   value:
                                          //       "${data.todayLowPrice.price.toString().numberFormat()} ${data.todayLowPrice.unit}",
                                          // ),
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
                                    )
                                  ],
                                ),
                              ),
                            ),
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

class HomeTradesWidget extends StatelessWidget {
  final List<TradeInfoDTO> trades;
  final Function(TradeInfoDTO, BuyAndSellType) onTradeTap;

  const HomeTradesWidget({
    super.key,
    required this.trades,
    required this.onTradeTap,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: const Color(0xffE5E5E5),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(children: [
          Expanded(
              child: Center(
                child: AppText(
                  'فروش',
                  textStyle: AppTextStyle.subTitle5,
                  color: AppColors.nature.shade900,
                ),
              )),
          Expanded(
              child: Center(
                child: AppText(
                  'خرید',
                  textStyle: AppTextStyle.subTitle5,
                  color: AppColors.nature.shade900,
                ),
              )),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: AppText(
                  trades.isNotEmpty ? (trades.first.isGold ? 'آبشده' : 'سکه') : '',
                  textStyle: AppTextStyle.subTitle5,
                  color: AppColors.nature.shade900,
                ),
              )),
        ]),
      ),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
            children: trades
                .map((e) => TradeShortcutWidget(
              tradeInfo: e,
              onTradeTap: onTradeTap,
            ))
                .toList()),
      ),
    ]),
  );
}

class TradeShortcutWidget extends StatelessWidget {
  final TradeInfoDTO tradeInfo;
  final Function(TradeInfoDTO, BuyAndSellType) onTradeTap;

  const TradeShortcutWidget({
    super.key,
    required this.tradeInfo,
    required this.onTradeTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Expanded(
        child: tradeInfo.sellStatus
            ? GestureDetector(
          onTap: () => onTradeTap.call(tradeInfo, BuyAndSellType.sell),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.red.shade600,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: AppText(
                tradeInfo.sellPrice.numberFormat(),
                textStyle: AppTextStyle.subTitle4,
                color: AppColors.nature.shade50,
              ),
            ),
          ),
        )
            : const SizedBox(),
      ),
      const SizedBox(width: 4),
      Expanded(
        child: tradeInfo.buyStatus
            ? GestureDetector(
          onTap: () => onTradeTap.call(tradeInfo, BuyAndSellType.buy),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.green.shade600,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: AppText(
                tradeInfo.buyPrice.numberFormat(),
                textStyle: AppTextStyle.subTitle4,
                color: AppColors.nature.shade50,
              ),
            ),
          ),
        )
            : const SizedBox(),
      ),
      const SizedBox(width: 4),
      Expanded(
        child: AppText(
          tradeInfo.title,
          textStyle: AppTextStyle.subTitle5,
          color: AppColors.nature.shade900,
        ),
      ),
    ]),
  );
}


class TopRadius extends StatelessWidget {
  final Color? backgroundColor;

  const TopRadius({
    super.key,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Container(
        width: double.maxFinite,
        height: 16,
        decoration: const BoxDecoration(
            color: AppColors.blue,
            borderRadius:
            BorderRadius.vertical(top: Radius.circular(16))),
      ),
      Container(
        width: double.maxFinite,
        margin: const EdgeInsets.only(top: 2),
        height: 16,
        decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.white,
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(16))),
      ),
    ],
  );
}

