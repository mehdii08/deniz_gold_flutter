import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/core/utils/extensions.dart';
import 'package:deniz_gold/data/enums.dart';
import 'package:deniz_gold/presentation/blocs/home/home_screen_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/UserAccountingChecker.dart';
import 'package:deniz_gold/presentation/widget/UserStatusChecker.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/balance_widget.dart';
import 'package:deniz_gold/presentation/widget/buy_and_sell_prices.dart';
import 'package:deniz_gold/presentation/widget/confirm_dialog.dart';
import 'package:deniz_gold/presentation/widget/logo_app_bar.dart';
import 'package:deniz_gold/presentation/widget/prices_list.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  @override
  Widget build(BuildContext context) => SafeArea(
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
          child: Scaffold(
            appBar: const LogoAppBar(),
            backgroundColor: AppColors.background,
            body: BlocProvider<HomeScreenCubit>(
              create: (_) => sl<HomeScreenCubit>()..getData(),
              child: BlocConsumer<HomeScreenCubit, HomeScreenState>(listener: (context, state) {
                if (state is HomeScreenFailed) {
                  showToast(title: state.message, context: context, toastType: ToastType.error);
                }
              }, builder: (context, state) {
                if (state is HomeScreenLoaded) {
                  final data = state.data;
                  return Column(
                    children: [
                      Container(
                        color: AppColors.white,
                        padding: const EdgeInsets.symmetric(horizontal: Dimens.standard16),
                        child: Column(
                          children: [
                            UserAccountingChecker(
                              updateUser: true,
                              placeHolder: const SizedBox(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: BalanceWidget(
                                          title: Strings.remainingRials,
                                          // balance: data.rialBalance.numberFormat(),
                                          balance: "replace me",
                                          icon: SvgPicture.asset("assets/images/gold_price.svg",
                                              width: Dimens.standard32, fit: BoxFit.fitWidth),
                                          iconAlign: IconAlign.left,
                                        ),
                                      ),
                                      const SizedBox(width: Dimens.standardX),
                                      Expanded(
                                        child: BalanceWidget(
                                          title: Strings.remainingGold,
                                          // balance: data.goldBalance.numberFormat(),
                                          balance: "replace me",
                                          icon: Image.asset("assets/images/iran_flagg.png", width: Dimens.standard32),
                                          iconAlign: IconAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: Dimens.standard4),
                            BuyAndSellPrices(
                              buyPrice: data.buyPrice,
                              sellPrice: data.sellPrice,
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
                                  value: "${data.goldOns} ${Strings.toman}",
                                ),
                                const SizedBox(height: Dimens.standard8),
                                KeyValueWidget(
                                  title: Strings.goldGheramPrice,
                                  value: "${data.goldGheram.numberFormat()} ${Strings.toman}",
                                ),
                                const SizedBox(height: Dimens.standard8),
                                KeyValueWidget(
                                  title: Strings.worldGoldPrice,
                                  value: "${data.goldWorld.numberFormat()} ${Strings.toman}",
                                ),
                                const SizedBox(height: Dimens.standard8),
                                KeyValueWidget(
                                  title: Strings.weekMaxPrice,
                                  value: "${data.todayHighPrice.numberFormat()} ${Strings.toman}",
                                ),
                                const SizedBox(height: Dimens.standard8),
                                KeyValueWidget(
                                  title: Strings.weekMinPrice,
                                  value: "${data.todayLowPrice.numberFormat()} ${Strings.toman}",
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
                                        Strings.sellPrice,
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
                                        Strings.sellPrice,
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
