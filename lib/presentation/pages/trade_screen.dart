import 'dart:async';

import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/core/utils/extensions.dart';
import 'package:deniz_gold/data/dtos/trade_calculate_response_dto.dart';
import 'package:deniz_gold/data/dtos/trade_submit_response_dto.dart';
import 'package:deniz_gold/data/enums.dart';
import 'package:deniz_gold/presentation/blocs/home/home_screen_cubit.dart';
import 'package:deniz_gold/presentation/blocs/trade/trade_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/pages/home_screen.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/UserStatusChecker.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/app_text_field.dart';
import 'package:deniz_gold/presentation/widget/logo_app_bar.dart';
import 'package:deniz_gold/presentation/widget/select_toman_or_weight.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';
import 'package:deniz_gold/presentation/widget/trade_switch_button.dart';
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
  final isTomanNotifier = ValueNotifier<bool>(false);
  final canSubmitNotifier = ValueNotifier<bool>(false);
  late ValueNotifier<TradeType> tradeTypeValueNotifier;
  final textController = TextEditingController(text: "0");
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    tradeTypeValueNotifier = ValueNotifier<TradeType>(widget.isSell ? TradeType.sell : TradeType.buy);
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
                  BlocProvider<TradeCubit>(
                    create: (_) => sl(),
                  ),
                ],
                child: ValueListenableBuilder<TradeType>(
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
                                  isSell: selectedTradeType == TradeType.sell,
                                  tradeCubit: context.read<TradeCubit>(),
                                  onConfirmClicked: () {
                                    context.read<TradeCubit>().submitTrade(
                                          tradeType:
                                              selectedTradeType == TradeType.sell ? TradeType.sell : TradeType.buy,
                                          calculateType:
                                              isTomanNotifier.value ? CalculateType.toman : CalculateType.weight,
                                          value: value.clearCommas(),
                                        );
                                  },
                                  onTradeSubmitted: (data) {
                                    Navigator.pop(context);
                                    _showTradeAnswerWaitingDialog(
                                      context: context,
                                      data: data,
                                      isSell: selectedTradeType == TradeType.sell,
                                      tradeCubit: context.read<TradeCubit>(),
                                    );
                                  });
                            } else if (state is TradeSubmited) {
                              context.pop();
                              showToast(title: state.message, context: context);
                              _showTradeAnswerWaitingDialog(
                                context: context,
                                data: state.data,
                                isSell: selectedTradeType == TradeType.sell,
                                tradeCubit: context.read<TradeCubit>(),
                              );
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
                                        child: TradeSwitchButton(
                                          selectedTradeType: selectedTradeType,
                                          onBuyPressed: () => tradeTypeValueNotifier.value = TradeType.buy,
                                          onSellPressed: () => tradeTypeValueNotifier.value = TradeType.sell,
                                        ),
                                      ),
                                      const SizedBox(height: Dimens.standard12),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: isTomanNotifier,
                                        builder: (context, isToman, _) => Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: Dimens.standard20),
                                              child: SelectTomanOrWeight(
                                                selectedTradeType: selectedTradeType,
                                                isToman: isToman,
                                                onTomanPressed: () {
                                                  isTomanNotifier.value = true;
                                                  textController.text = "0";
                                                  canSubmitNotifier.value = false;
                                                },
                                                onWeightPressed: () {
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
                                                  borderRadius:
                                                      BorderRadius.vertical(top: Radius.circular(Dimens.standard16))),
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
                                                      onTap: () => textController.increaseValue(),
                                                      child: SvgPicture.asset(
                                                        'assets/images/plus.svg',
                                                        width: Dimens.standard6,
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                    ),
                                                    suffixIcon: GestureDetector(
                                                      onTap: () => textController.decreaseValue(),
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
                                                        " ${selectedTradeType == TradeType.sell ? homeState.data.sellPrice.numberFormat() : homeState.data.buyPrice.numberFormat()}"
                                                        "${Strings.toman}",
                                                        textStyle: AppTextStyle.body4,
                                                        color: AppColors.nature.shade900,
                                                      ),
                                                      AppText(
                                                        Strings.eachGeramPrice_,
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
                                                      color: selectedTradeType == TradeType.buy
                                                          ? AppColors.green
                                                          : AppColors.red,
                                                      onPressed: canSubmit
                                                          ? () {
                                                              focusNode.unfocus();
                                                              context.read<TradeCubit>().getTradeCalculateData(
                                                                    tradeType: selectedTradeType == TradeType.sell
                                                                        ? TradeType.sell
                                                                        : TradeType.buy,
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
          _showTradeAnswerWaitingDialog(
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

_showTradeAnswerWaitingDialog({
  required BuildContext context,
  required TradeSubmitResponseDTO data,
  required bool isSell,
  required TradeCubit tradeCubit,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return TradeAnswerWaitingDialog(
        data: data,
        isSell: isSell,
        tradeCubit: tradeCubit,
        onCounterEnded: () {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (_) => TradeAnswerDialog(
              isSell: isSell,
              status: "0",
            ),
          );
        },
      );
    },
  );
}

class TradeAnswerWaitingDialog extends StatefulWidget {
  final TradeSubmitResponseDTO data;
  final bool isSell;
  final TradeCubit tradeCubit;
  final VoidCallback onCounterEnded;

  const TradeAnswerWaitingDialog({
    Key? key,
    required this.data,
    required this.isSell,
    required this.tradeCubit,
    required this.onCounterEnded,
  }) : super(key: key);

  @override
  State<TradeAnswerWaitingDialog> createState() => _TradeAnswerWaitingDialogState();
}

class _TradeAnswerWaitingDialogState extends State<TradeAnswerWaitingDialog> with TickerProviderStateMixin {
  late Timer _timer;
  int _progress = 0;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_progress == 60) {
          widget.onCounterEnded();
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _progress++;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TradeCubit, TradeState>(
      bloc: widget.tradeCubit,
      listener: (context, state) {
        if (state is TradeAnswerReached) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (_) => TradeAnswerDialog(
              isSell: widget.isSell,
              status: state.status,
              totalPrice: state.totalPrice,
              mazaneh: state.mazaneh,
              weight: state.weight,
            ),
          );
        }
      },
      builder: (context, state) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Dimens.standard16))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Dimens.standard53,
              height: Dimens.standard53,
              padding: const EdgeInsets.all(Dimens.standard16),
              decoration: BoxDecoration(color: AppColors.nature, shape: BoxShape.circle),
              child: SvgPicture.asset(
                'assets/images/time.svg',
                width: Dimens.standard20,
                fit: BoxFit.fitWidth,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: Dimens.standard16),
            AppText(
              Strings.validatingOrder,
              textStyle: AppTextStyle.subTitle3,
            ),
            AppText(
              widget.isSell ? Strings.sellDescription : Strings.buyDescription,
              textStyle: AppTextStyle.body4,
              color: AppColors.nature.shade700,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimens.standard40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.standard53),
              child: RotatedBox(
                quarterTurns: 2,
                child: LinearProgressIndicator(
                  backgroundColor: AppColors.nature.shade50,
                  color: AppColors.yellow,
                  value: _progress.toDouble() / 60,
                  minHeight: 12,
                ),
              ),
            ),
            const SizedBox(height: Dimens.standard40),
          ],
        ),
      ),
    );
  }
}

class TradeAnswerDialog extends StatelessWidget {
  final bool isSell;
  final String status;
  final String? totalPrice;
  final String? mazaneh;
  final String? weight;

  const TradeAnswerDialog({
    Key? key,
    required this.isSell,
    required this.status,
    this.totalPrice,
    this.mazaneh,
    this.weight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSuccessful = status == "1";
    if (!isSuccessful) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Dimens.standard16))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Dimens.standard53,
              height: Dimens.standard53,
              padding: const EdgeInsets.all(Dimens.standard16),
              decoration: BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
              child: SvgPicture.asset(
                'assets/images/close.svg',
                width: Dimens.standard20,
                fit: BoxFit.fitWidth,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: Dimens.standard16),
            AppText(
              Strings.orderNotConfirmed,
              textStyle: AppTextStyle.subTitle3,
            ),
            AppText(
              Strings.orderNotConfirmedDescription,
              textStyle: AppTextStyle.body4,
              color: AppColors.nature.shade700,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimens.standard24),
            AppButton(
              onPressed: () {
                context.pop();
                showSupportBottomSheet(context : context);
              },
              text: Strings.callToSupport,
              svgIcon: 'assets/images/support.svg',
            ),
            const SizedBox(height: Dimens.standard24),
          ],
        ),
      );
    }
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Dimens.standard16))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Dimens.standard53,
            height: Dimens.standard53,
            padding: const EdgeInsets.all(Dimens.standard16),
            decoration: BoxDecoration(color: AppColors.yellow, shape: BoxShape.circle),
            child: SvgPicture.asset(
              'assets/images/done_check.svg',
              width: Dimens.standard20,
              fit: BoxFit.fitWidth,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: Dimens.standard16),
          AppText(
            Strings.orderConfirmed,
            textStyle: AppTextStyle.subTitle3,
          ),
          const SizedBox(height: Dimens.standard24),
          Row(
            children: [
              AppText(
                isSell ? Strings.sellGold : Strings.buyGold,
                textStyle: AppTextStyle.body4,
              ),
              const Spacer(),
              AppText(
                Strings.tradeType_,
                textStyle: AppTextStyle.body4,
                color: AppColors.nature.shade700,
              ),
            ],
          ),
          const SizedBox(height: Dimens.standard8),
          Row(
            children: [
              AppText(
                "${mazaneh.clearCommas().numberFormat()} ${Strings.toman}",
                textStyle: AppTextStyle.body4,
              ),
              const Spacer(),
              AppText(
                Strings.goldGheramPrice,
                textStyle: AppTextStyle.body4,
                color: AppColors.nature.shade700,
              ),
            ],
          ),
          const SizedBox(height: Dimens.standard8),
          Row(
            children: [
              AppText(
                "$weight ${Strings.geram}",
                textStyle: AppTextStyle.body4,
              ),
              const Spacer(),
              AppText(
                Strings.requestedWeight,
                textStyle: AppTextStyle.body4,
                color: AppColors.nature.shade700,
              ),
            ],
          ),
          const SizedBox(height: Dimens.standard20),
          const Divider(),
          const SizedBox(height: Dimens.standard12),
          Row(
            children: [
              AppText(
                "${totalPrice.numberFormat()} ${Strings.toman}",
                textStyle: AppTextStyle.body4,
              ),
              const Spacer(),
              AppText(
                Strings.tradeTotalPrice,
                textStyle: AppTextStyle.body4,
                color: AppColors.nature.shade700,
              ),
            ],
          ),
          const SizedBox(height: Dimens.standard28),
          AppButton(
            text: Strings.understand,
            onPressed: () => context.pop(),
            color: AppColors.nature.shade50,
          ),
          const SizedBox(height: Dimens.standard24),
        ],
      ),
    );
  }
}
