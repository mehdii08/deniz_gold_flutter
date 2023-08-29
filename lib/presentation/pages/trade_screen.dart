import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/core/utils/extensions.dart';
import 'package:deniz_gold/data/dtos/trade_calculate_response_dto.dart';
import 'package:deniz_gold/data/enums.dart';
import 'package:deniz_gold/presentation/blocs/home/home_screen_cubit.dart';
import 'package:deniz_gold/presentation/blocs/trade/trade_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/pages/home_screen.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/UserStatusChecker.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:deniz_gold/presentation/widget/app_switch_button.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/app_text_field.dart';
import 'package:deniz_gold/presentation/widget/logo_app_bar.dart';
import 'package:deniz_gold/presentation/widget/permisson_checker.dart';
import 'package:deniz_gold/presentation/widget/select_left_or_right.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';
import 'package:deniz_gold/presentation/widget/utils.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class TradeScreen extends StatefulWidget {
  final bool isSell;

  const TradeScreen({
    Key? key,
    required this.isSell,
  }) : super(key: key);

  static final route = GoRoute(
    name: 'TradeScreen',
    path: '/trade',
    builder: (_, state) {
      final isSell = state.queryParams['is_sell'] == "true";
      return TradeScreen(key: ValueKey(DateTime.now()), isSell: isSell);
    },
  );

  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  final scrollController = ScrollController();
  final cubit = sl<HomeScreenCubit>()..getData();
  final tradeCubit = sl<TradeCubit>();
  final isTomanNotifier = ValueNotifier<bool>(false);
  final canSubmitNotifier = ValueNotifier<bool>(false);
  late ValueNotifier<BuyAndSellType> tradeTypeValueNotifier;
  final textController = TextEditingController(text: "0");
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    tradeTypeValueNotifier = ValueNotifier<BuyAndSellType>(widget.isSell ? BuyAndSellType.sell : BuyAndSellType.buy);
    cubit.getData();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => UserStatusChecker(
        child: SafeArea(
          child: PermissionChecker(
            child: WillPopScope(
              onWillPop: () async {
                context.goNamed(HomeScreen.route.name!);
                return false;
              },
              child: Scaffold(
                backgroundColor: AppColors.background,
                appBar: const LogoAppBar(),
                body: MultiBlocProvider(
                    providers: [
                      BlocProvider<HomeScreenCubit>(
                        create: (_) => cubit,
                      ),
                      BlocProvider<TradeCubit>.value(
                        value: tradeCubit,
                      ),
                    ],
                    child: ValueListenableBuilder<BuyAndSellType>(
                      valueListenable: tradeTypeValueNotifier,
                      builder: (context, selectedTradeType, _) => MultiBlocListener(
                          listeners: [
                            BlocListener<HomeScreenCubit, HomeScreenState>(
                              listener: (context, state) {
                                if (state is HomeScreenFailed) {
                                  showToast(title: state.message, context: context, toastType: ToastType.error);
                                }
                              },
                            ),
                            BlocListener<TradeCubit, TradeState>(
                              listener: (context, state) {
                                if (state is TradeFailed) {
                                  showToast(title: state.message, context: context, toastType: ToastType.error);
                                } else if (state is TradeCalculateLoaded) {
                                  final value = textController.text;
                                  textController.text = "0";
                                  canSubmitNotifier.value = false;
                                  showTradeCalculateDataBottomSheet(
                                      context: context,
                                      data: state.data,
                                      isSell: selectedTradeType == BuyAndSellType.sell,
                                      tradeCubit: context.read<TradeCubit>(),
                                      onConfirmClicked: () {
                                        context.read<TradeCubit>().submitTrade(
                                              tradeType:
                                                  selectedTradeType == BuyAndSellType.sell ? BuyAndSellType.sell : BuyAndSellType.buy,
                                              calculateType:
                                                  isTomanNotifier.value ? CalculateType.toman : CalculateType.weight,
                                              value: value.clearCommas(),
                                            );
                                      },
                                      onTradeSubmitted: (data) {
                                        context.pop();
                                        showTradeAnswerWaitingDialog(
                                          context: context,
                                          data: data,
                                          isSell: selectedTradeType == BuyAndSellType.sell,
                                          tradeCubit: context.read<TradeCubit>(),
                                        );
                                      });
                                } else if (state is TradeSubmited) {
                                  showToast(title: state.message, context: context);
                                }
                              },
                            ),
                          ],
                          child: BlocBuilder<HomeScreenCubit, HomeScreenState>(
                            builder: (context, homeState) =>
                                BlocBuilder<TradeCubit, TradeState>(builder: (context, tradeState) {
                              if (homeState is HomeScreenLoaded) {
                                return Column(
                                  children: [
                                    Container(
                                      color: AppColors.white,
                                      child: Column(
                                        children: [
                                          const SizedBox(height: Dimens.standard20),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: Dimens.standard20),
                                            child: AppSwitchButton(
                                              selectedSide: selectedTradeType == BuyAndSellType.buy
                                                  ? SwitchSide.right
                                                  : SwitchSide.left,
                                              onRightPressed: () => tradeTypeValueNotifier.value = BuyAndSellType.buy,
                                              onLeftPressed: () => tradeTypeValueNotifier.value = BuyAndSellType.sell,
                                            ),
                                          ),
                                          const SizedBox(height: Dimens.standard12),
                                          ValueListenableBuilder<bool>(
                                            valueListenable: isTomanNotifier,
                                            builder: (context, isToman, _) => Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: Dimens.standard20),
                                                  child: SelectLeftOrRight(
                                                    isLeftSelected: isToman,
                                                    leftTitle: selectedTradeType == BuyAndSellType.sell ? Strings.tomanBaseSell : Strings.tomanBaseBuy,
                                                    rightTitle: selectedTradeType == BuyAndSellType.sell ? Strings.weightBaseSell : Strings.weightBaseBuy,
                                                    onLeftPressed: () {
                                                      isTomanNotifier.value = true;
                                                      textController.text = "0";
                                                      canSubmitNotifier.value = false;
                                                    },
                                                    onRightPressed: () {
                                                      isTomanNotifier.value = false;
                                                      textController.text = "0";
                                                      canSubmitNotifier.value = false;
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: Dimens.standard20),
                                                  decoration: const BoxDecoration(
                                                      color: AppColors.background,
                                                      borderRadius: BorderRadius.vertical(
                                                          top: Radius.circular(Dimens.standard16))),
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(height: Dimens.standard28),
                                                      AppTextField(
                                                        title: isToman
                                                            ? Strings.enterPriceByToman
                                                            : Strings.enterWeightByGheram,
                                                        focusNode: focusNode,
                                                        controller: textController,
                                                        keyboardType: TextInputType.number,
                                                        onChange: (value) {
                                                          value = value.clearCommas().numberFormat();
                                                          textController.value = TextEditingValue(
                                                            text: value,
                                                            selection: TextSelection.collapsed(offset: value.length),
                                                          );
                                                          canSubmitNotifier.value =
                                                              isValidNumInput(value: value.replaceAll(",", ""));
                                                        },
                                                        prefixIcon: GestureDetector(
                                                          onTap: () {
                                                            textController.increaseValue();
                                                            canSubmitNotifier.value = isValidNumInput(
                                                                value: textController.text.replaceAll(",", ""));
                                                          },
                                                          child: SvgPicture.asset(
                                                            'assets/images/plus.svg',
                                                            width: Dimens.standard6,
                                                            fit: BoxFit.fitWidth,
                                                          ),
                                                        ),
                                                        suffixIcon: GestureDetector(
                                                          onTap: () {
                                                            textController.decreaseValue();
                                                            canSubmitNotifier.value = isValidNumInput(
                                                                value: textController.text.replaceAll(",", ""));
                                                          },
                                                          child: SvgPicture.asset(
                                                            'assets/images/negativ.svg',
                                                            width: Dimens.standard6,
                                                            fit: BoxFit.fitWidth,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: Dimens.standard16),
                                                      Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          AppText(
                                                            "${selectedTradeType == BuyAndSellType.sell ? homeState.data.sellPrice.price.numberFormat() : homeState.data.buyPrice.price.numberFormat()}"
                                                            " ${selectedTradeType == BuyAndSellType.sell ? homeState.data.sellPrice.unit : homeState.data.buyPrice.unit}",
                                                            textStyle: AppTextStyle.body4,
                                                            color: AppColors.nature.shade900,
                                                          ),
                                                          AppText(
                                                            Strings.eachMesgalPrice_,
                                                            textStyle: AppTextStyle.body4,
                                                            color: AppColors.nature.shade700,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: Dimens.standard16),
                                                      ValueListenableBuilder<bool>(
                                                        valueListenable: canSubmitNotifier,
                                                        builder: (context, canSubmit, _) => AppButton(
                                                          isLoading:
                                                              tradeState is TradeLoading && tradeState.calculateLoading,
                                                          text: Strings.calculateOrder,
                                                          textColor: AppColors.white,
                                                          color: selectedTradeType == BuyAndSellType.buy
                                                              ? AppColors.green
                                                              : AppColors.red,
                                                          onPressed: canSubmit
                                                              ? () {
                                                                  focusNode.unfocus();
                                                                  context.read<TradeCubit>().getTradeCalculateData(
                                                                        tradeType: selectedTradeType == BuyAndSellType.sell
                                                                            ? BuyAndSellType.sell
                                                                            : BuyAndSellType.buy,
                                                                        calculateType: isTomanNotifier.value
                                                                            ? CalculateType.toman
                                                                            : CalculateType.weight,
                                                                        value: textController.text.clearCommas(),
                                                                      );
                                                                }
                                                              : null,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }),
                          )),
                    )),
              ),
            ),
          ),
        ),
      );

  bool isValidNumInput({required String value}) {
    try {
      final intVal = int.parse(value);
      return intVal != 0;
    } on Exception catch (_, __) {
      return false;
    }
  }
}

class TradeInfoDialog extends StatefulWidget {
  final TradeCalculateResponseDTO data;
  final bool isSell;
  final VoidCallback onConfirmClicked;
  final TradeCubit tradeCubit;

  const TradeInfoDialog({
    Key? key,
    required this.data,
    required this.isSell,
    required this.tradeCubit,
    required this.onConfirmClicked,
  }) : super(key: key);

  @override
  State<TradeInfoDialog> createState() => _TradeInfoDialogState();
}

class _TradeInfoDialogState extends State<TradeInfoDialog> {
  late BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TradeCubit, TradeState>(
      bloc: widget.tradeCubit,
      listener: (context, state) {
        if (state is TradeSubmited) {
          Navigator.pop(context);
          showTradeAnswerWaitingDialog(
            context: context,
            data: state.data,
            isSell: widget.isSell,
            tradeCubit: widget.tradeCubit,
          );
        }
      },
      builder: (context, state) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/check.png',
              width: 40,
            ),
            const SizedBox(height: Dimens.standardX),
            Text(
              widget.isSell ? Strings.sellOrderConfirmation : Strings.buyOrderConfirmation,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: widget.isSell ? AppColors.red : AppColors.green),
            ),
            const SizedBox(height: Dimens.standardX),
            const Divider(),
            const SizedBox(height: Dimens.standardX),
            Text(
              "${Strings.orderMazane} : ${widget.data.mazaneh.clearCommas().numberFormat()} ${Strings.toman}",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.nature),
            ),
            const SizedBox(height: Dimens.standard2X),
            Text(
              "${Strings.requestedWeight} : ${widget.data.weight} ${Strings.geram}",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.nature),
            ),
            const SizedBox(height: Dimens.standard2X),
            Text(
              "${Strings.orderPrice} : ${widget.data.totalPrice.clearCommas().numberFormat()} ${Strings.toman}",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.nature),
            ),
            const SizedBox(height: Dimens.standard2X),
            Row(
              children: [
                Expanded(
                    child: AppButton(
                        color: AppColors.red,
                        text: Strings.cancel,
                        onPressed: () {
                          Navigator.of(context).pop();
                        })),
                const SizedBox(width: Dimens.standardX),
                Expanded(
                    child: AppButton(
                  isLoading: state is TradeLoading && state.submitLoading,
                  text: Strings.confirm,
                  onPressed: widget.onConfirmClicked,
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
