import 'package:collection/collection.dart';
import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/data/enums.dart';
import 'package:deniz_gold/presentation/blocs/coin_shop/coin_shop_screen_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/pages/home_screen.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:deniz_gold/presentation/widget/coin_item.dart';
import 'package:deniz_gold/presentation/widget/logo_app_bar.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';
import 'package:deniz_gold/presentation/widget/utils.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../widget/app_switch_button.dart';

class CoinShopScreen extends StatefulWidget {
  const CoinShopScreen({Key? key}) : super(key: key);

  static final route = GoRoute(
    name: 'CoinShopScreen',
    path: '/coin-shop',
    builder: (_, state) {
      return const CoinShopScreen();
    },
  );

  @override
  State<CoinShopScreen> createState() => _CoinShopScreenState();
}

class _CoinShopScreenState extends State<CoinShopScreen> {
  final selectedTradeTypeNotifier = ValueNotifier<BuyAndSellType>(BuyAndSellType.buy);
  final CoinTabCubit cubit = sl()..getData();

  @override
  void initState() {
    super.initState();
    cubit.eventStream.listen((event) {
      if (event == CoinTabEvent.showCalculateBottomSheet) {
        showCoinTradeCalculateDataBottomSheet(
          context: context,
          data: cubit.state.coinTradeCalculateResponseDTO!,
          type: selectedTradeTypeNotifier.value,
          onConfirmClicked: () {},
          onTradeSubmitted: (data) {},
          coinTabCubit: cubit,
        );
      } else if (event == CoinTabEvent.showWaitingDialog) {
        context.pop();
        showCoinTradeAnswerWaitingDialog(context: context, data: cubit.state.coinTradeSubmitResponseDTO!);
      }
    });

    cubit.errorStream.listen((event) {
      showToast(title: event, context: context, toastType: ToastType.error);
    });
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        context.goNamed(HomeScreen.route.name ?? '');
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: const LogoAppBar(),
          body: BlocProvider<CoinTabCubit>.value(
            value: cubit,
            child: BlocBuilder<CoinTabCubit, CoinTabState>(builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              final coinTabCubit = context.read<CoinTabCubit>();
              final coins = state.coins;
              return ValueListenableBuilder<BuyAndSellType>(
                  valueListenable: selectedTradeTypeNotifier,
                  builder: (context, selectedTradeType, _) {
                    return Column(
                      children: [
                        const SizedBox(height: Dimens.standard20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimens.standard16),
                          child: AppSwitchButton(
                            rightTitle: Strings.buyCoin,
                            leftTitle: Strings.sellCoin,
                            selectedSide: selectedTradeType == BuyAndSellType.buy ? SwitchSide.right : SwitchSide.left,
                            onRightPressed: () => selectedTradeTypeNotifier.value = BuyAndSellType.buy,
                            onLeftPressed: () => selectedTradeTypeNotifier.value = BuyAndSellType.sell,
                          ),
                        ),
                        const SizedBox(height: Dimens.standard12),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimens.standard20),
                              child: Column(
                                children: [
                                  const SizedBox(height: Dimens.standard16),
                                  ...coins
                                      .map((e) => CoinItem(
                                    coin: e,
                                    isSell: selectedTradeType == BuyAndSellType.sell,
                                    count: state.selectedCoins
                                        .firstWhereOrNull((element) => e.id == element.id)
                                        ?.count ??
                                        0,
                                  ))
                                      .toList(),
                                  const SizedBox(height: Dimens.standard32),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimens.standard20),
                          child: AppButton(
                            onPressed: coinTabCubit.cartIsEmpty() ? null : () => coinTabCubit.calculate(type: selectedTradeType),
                            isLoading: state.buttonIsLoading,
                            text: '${selectedTradeType == BuyAndSellType.buy ? Strings.submitBuyOrder : Strings.submitSellOrder} (${coinTabCubit.cartCount()} ${Strings.count})',
                            color: selectedTradeType == BuyAndSellType.buy ? AppColors.green : AppColors.red,
                            textColor: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: Dimens.standard80),
                      ],
                    );
                  });
            }),
          ),
        ),
      ));
}
