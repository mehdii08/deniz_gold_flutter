import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/core/utils/extensions.dart';
import 'package:deniz_gold/data/dtos/trade_info_dto.dart';
import 'package:deniz_gold/data/enums.dart';
import 'package:deniz_gold/presentation/blocs/home/home_screen_cubit.dart';
import 'package:deniz_gold/presentation/blocs/trade/trade_cubit.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/app_text_field.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';
import 'package:deniz_gold/presentation/widget/utils.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

import '../blocs/app_config/app_config_cubit.dart';

class TradeBottomSheet extends StatefulWidget {
  final TradeInfoDTO tradeInfo;
  final BuyAndSellType buyAndSellType;

  const TradeBottomSheet({
    super.key,
    required this.tradeInfo,
    required this.buyAndSellType,
  });

  @override
  State<TradeBottomSheet> createState() => _TradeBottomSheetState();
}

class _TradeBottomSheetState extends State<TradeBottomSheet> {
  final goldWeightController = TextEditingController();
  final goldPriceController = TextEditingController();
  final coinCountController = TextEditingController();
  final coinPriceController = TextEditingController();

  late TradeInfoDTO tradeInfo;

  late bool _isVIPUser;

  bool _weightChangedLastTime = true;

  @override
  void initState() {
    tradeInfo = widget.tradeInfo;
    _isVIPUser = context.read<AppConfigCubit>().state.appConfig?.user.isVIP ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<TradeCubit>(create: (_) => sl()),
          // BlocProvider<HomeScreenCubit>(create: (_) => sl())
        ],
        child: BlocListener<HomeScreenCubit, HomeScreenState>(
          listener: (context, state) {
            if (state is HomeScreenLoaded) {
              if (tradeInfo.isGold) {
                final newTrade = state.data.trades
                    .firstWhereOrNull((e) => e.id == tradeInfo.id);
                if (newTrade != null) {
                  setState(() {
                    tradeInfo = newTrade;
                  });
                  if (_weightChangedLastTime) {
                    _onGoldWeightChange(goldWeightController.text);
                  } else {
                    _onGoldPriceChange(goldPriceController.text);
                  }
                }
              } else {
                final newTrade = state.data.coins
                    .firstWhereOrNull((e) => e.id == tradeInfo.id);
                if (newTrade != null) {
                  setState(() {
                    tradeInfo = newTrade;
                  });
                  _onCoinCountChange(coinCountController.text);
                }
              }
            }
          },
          child: BlocConsumer<TradeCubit, TradeState>(
              listener: (context, tradeState) {
            if (tradeState is TradeSubmited) {
              Navigator.pop(context);
              showTradeAnswerWaitingDialog(
                context: context,
                data: tradeState.data,
                isSell: widget.buyAndSellType.isSell,
                tradeCubit: context.read<TradeCubit>(),
              );
            } else if (tradeState is TradeFailed) {
              showToast(
                  title: tradeState.message,
                  context: context,
                  toastType: ToastType.error);
            }
          }, builder: (context, tradeState) {
            return BlocBuilder<HomeScreenCubit, HomeScreenState>(
                builder: (context, homeState) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (tradeInfo.isGold) ...[
                      Row(children: [
                        const Spacer(),
                        AppText(
                          'تومان',
                          textStyle: AppTextStyle.body4,
                          color: AppColors.nature.shade500,
                        ),
                        const SizedBox(width: 8),
                        AppText(
                          widget.buyAndSellType.isSell
                              ? tradeInfo.getSellPrice(isVIP: _isVIPUser).numberFormat()
                              : tradeInfo.getBuyPrice(isVIP: _isVIPUser).numberFormat(),
                          textStyle: AppTextStyle.subTitle3,
                          color: AppColors.nature.shade900,
                        ),
                        const SizedBox(width: 8),
                        AppText(
                          'مظنه:',
                          textStyle: AppTextStyle.body4,
                          color: AppColors.nature.shade500,
                        ),
                      ]),
                      const SizedBox(height: 28),
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: AppText(
                          'وزن (گرم)',
                          textStyle: AppTextStyle.subTitle4,
                          color: AppColors.nature.shade400,
                        ),
                      ),
                      AppTextField(
                        controller: goldWeightController,
                        textAlign: TextAlign.right,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onChange: _onGoldWeightChange,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: AppText(
                          'مبلغ کل (تومان)',
                          textStyle: AppTextStyle.subTitle4,
                          color: AppColors.nature.shade400,
                        ),
                      ),
                      AppTextField(
                        controller: goldPriceController,
                        textAlign: TextAlign.right,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onChange: _onGoldPriceChange,
                      ),
                    ] else ...[
                      Row(children: [
                        const Spacer(),
                        AppText(
                          'تومان',
                          textStyle: AppTextStyle.body4,
                          color: AppColors.nature.shade500,
                        ),
                        const SizedBox(width: 8),
                        AppText(
                          widget.buyAndSellType.isSell
                              ? tradeInfo.getSellPrice(isVIP: _isVIPUser).numberFormat()
                              : tradeInfo.getBuyPrice(isVIP: _isVIPUser).numberFormat(),
                          textStyle: AppTextStyle.subTitle3,
                          color: AppColors.nature.shade900,
                        ),
                        const SizedBox(width: 8),
                        AppText(
                          'قیمت:',
                          textStyle: AppTextStyle.body4,
                          color: AppColors.nature.shade500,
                        ),
                      ]),
                      const SizedBox(height: 28),
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: AppText(
                          'تعداد',
                          textStyle: AppTextStyle.subTitle4,
                          color: AppColors.nature.shade400,
                        ),
                      ),
                      AppTextField(
                        controller: coinCountController,
                        textAlign: TextAlign.right,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onChange: _onCoinCountChange,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: AppText(
                          'مبلغ کل (تومان)',
                          textStyle: AppTextStyle.subTitle4,
                          color: AppColors.nature.shade400,
                        ),
                      ),
                      AppTextField(
                        controller: coinPriceController,
                        textAlign: TextAlign.right,
                        enabled: false,
                        // backgroundColor: AppColors.nature.shade500,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                    ],
                    const SizedBox(height: 8),
                    if(goldPriceController.text.toInt() > 99 && goldPriceController.text.toInt() < 999999999999 )
                    AppText(
                      '${numberToWords(goldPriceController.text.toInt())} تومان ',
                      textStyle: AppTextStyle.body5,
                      color: AppColors.nature.shade300,
                    ),
                    if(coinPriceController.text.toInt() > 99 && coinPriceController.text.toInt() < 999999999999 )
                      AppText(
                        '${numberToWords(coinPriceController.text.toInt())} تومان ',
                        textStyle: AppTextStyle.body5,
                        color: AppColors.nature.shade300,
                      ),
                    const SizedBox(height: 44),
                    AppButton(
                      isLoading: tradeState is TradeLoading,
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (tradeInfo.isGold) {
                          context.read<TradeCubit>().submitTrade(
                                tradeId: tradeInfo.id,
                                tradeType: widget.buyAndSellType,
                                weight: goldWeightController.text,
                              );
                        } else {
                          int count = 0;

                          try {
                            count = int.parse(coinCountController.text
                                .replacePersianNumbers());
                          } catch (e) {}

                          context.read<TradeCubit>().submitCoinTrade(
                                coinId: tradeInfo.id,
                                tradeType: widget.buyAndSellType,
                                count: count,
                              );
                        }
                      },
                      text: 'ثبت سفارش',
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              );
            });
          }),
        ),
      );

  _onGoldWeightChange(String weight) {
    _weightChangedLastTime = true;
    String newWeight =
        weight.replacePersianNumbers().removeExtraDecimals().clearCommas();

    final unitPrice =
    widget.buyAndSellType.isSell ? (tradeInfo as GoldTradeInfoDTO).getSellPriceGheram(isVIP: _isVIPUser) : (tradeInfo as GoldTradeInfoDTO).getBuyPriceGheram(isVIP: _isVIPUser);
    final priceNewValue = newWeight.toDouble() * unitPrice.toDouble();
    goldPriceController.text =
        priceNewValue.toString().removeDecimals().numberFormat();
    newWeight = newWeight.numberFormat();
    goldWeightController.value = TextEditingValue(
      text: newWeight,
      selection: TextSelection.collapsed(offset: newWeight.length),
    );
    setState(() {});
  }

  _onGoldPriceChange(String price) {
    _weightChangedLastTime = false;
    String newPrice =
        price.replacePersianNumbers().removeDecimals().clearCommas();

    final unitPrice =
    widget.buyAndSellType.isSell ? (tradeInfo as GoldTradeInfoDTO).getSellPriceGheram(isVIP: _isVIPUser) : (tradeInfo as GoldTradeInfoDTO).getBuyPriceGheram(isVIP: _isVIPUser);

    double weightNewValue = newPrice.toDouble() / unitPrice.toDouble();
    if (weightNewValue < 0.001) weightNewValue = 0;
    goldWeightController.text =
        weightNewValue.toString().removeExtraDecimals().numberFormat();
    newPrice = newPrice.numberFormat();
    goldPriceController.value = TextEditingValue(
      text: newPrice,
      selection: TextSelection.collapsed(offset: newPrice.length),
    );
    setState(() {});
  }

  _onCoinCountChange(String count) {
    String newCount =
        count.replacePersianNumbers().removeDecimals().clearCommas();

    final unitPrice =
    widget.buyAndSellType.isSell ? tradeInfo.getSellPrice(isVIP: _isVIPUser) : tradeInfo.getBuyPrice(isVIP: _isVIPUser);
    final priceNewValue = newCount.toDouble() * unitPrice.toDouble();
    coinPriceController.text =
        priceNewValue.toString().removeDecimals().numberFormat();
    newCount = newCount.numberFormat();
    coinCountController.value = TextEditingValue(
      text: newCount,
      selection: TextSelection.collapsed(offset: newCount.length),
    );
    setState(() {});
  }

  String numberToWords(int number) {
    if (number < 0 || number > 999999999999) {
      return '';
    }

    if (number == 0) {
      return 'صفر';
    }

    List<String> units = [
      '', 'یک', 'دو', 'سه', 'چهار', 'پنج', 'شش', 'هفت', 'هشت', 'نه'
    ];

    List<String> teens = [
      'ده', 'یازده', 'دوازده', 'سیزده', 'چهارده', 'پانزده', 'شانزده', 'هفده', 'هجده', 'نوزده'
    ];

    List<String> tens = [
      '', '', 'بیست', 'سی', 'چهل', 'پنجاه', 'شصت', 'هفتاد', 'هشتاد', 'نود'
    ];

    List<String> hundreds = [
      '', 'صد', 'دویست', 'سیصد', 'چهارصد', 'پانصد', 'ششصد', 'هفتصد', 'هشتصد', 'نهصد'
    ];

    List<String> thousands = [
      '', 'هزار', 'میلیون', 'میلیارد'
    ];

    String convertLessThanOneThousand(int num) {
      if (num == 0) {
        return '';
      }

      String words = '';

      if (num >= 100) {
        words += hundreds[num ~/ 100];
        num %= 100;
        if (num > 0) {
          words += ' و ';
        }
      }

      if (num >= 10 && num <= 19) {
        words += teens[num - 10];
      } else {
        if (num >= 20) {
          words += tens[num ~/ 10];
          num %= 10;
          if (num > 0) {
            words += ' و ';
          }
        }
        if (num > 0) {
          words += units[num];
        }
      }

      return words;
    }

    String convertThousands(int num, int index) {
      if (num == 0) {
        return '';
      }

      return '${convertLessThanOneThousand(num)} ${thousands[index]}';
    }

    String words = '';
    int thousandIndex = 0;

    while (number > 0) {
      int remainder = number % 1000;
      if (remainder != 0) {
        String segment = convertThousands(remainder, thousandIndex);
        if (words.isNotEmpty) {
          words = '$segment و $words';
        } else {
          words = segment;
        }
      }
      number ~/= 1000;
      thousandIndex++;
    }

    return words.trim();
  }
}
