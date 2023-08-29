import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/core/utils/extensions.dart';
import 'package:deniz_gold/data/dtos/trade_submit_response_dto.dart';
import 'package:deniz_gold/presentation/blocs/coin_shop/coin_shop_screen_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/dtos/coin_trade_calculate_response_dto.dart';
import '../../data/enums.dart';

class CoinTradeCalculateDataBottomSheetContent extends StatelessWidget {
  final CoinTradeCalculateResponseDTO data;
  final BuyAndSellType type;
  final Function(TradeSubmitResponseDTO) onTradeSubmitted;
  final CoinTabCubit coinTabCubit;

  const CoinTradeCalculateDataBottomSheetContent({
    Key? key,
    required this.data,
    required this.type,
    required this.onTradeSubmitted,
    required this.coinTabCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<CoinTabCubit, CoinTabState>(
        bloc: coinTabCubit,
        builder: (context, state) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.standard16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: Dimens.standard8),
              Row(
                children: [
                  AppText(
                    type == BuyAndSellType.sell ? Strings.sellCoin : Strings.buyCoin,
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
              ...state.coinTradeCalculateResponseDTO?.coins
                      .map((e) => Column(
                            children: [
                              const SizedBox(height: Dimens.standard8),
                              Row(
                                children: [
                                  AppText(
                                    '${e.count} عدد',
                                    textStyle: AppTextStyle.body4,
                                  ),
                                  const Spacer(),
                                  AppText(
                                    e.title,
                                    textStyle: AppTextStyle.body4,
                                    color: AppColors.nature.shade700,
                                  ),
                                ],
                              ),
                            ],
                          ))
                      .toList() ??
                  [],
              const SizedBox(height: Dimens.standard20),
              const Divider(),
              const SizedBox(height: Dimens.standard12),
              Row(
                children: [
                  AppText(
                    '${state.coinTradeCalculateResponseDTO?.pricesSum.numberFormat()} تومان',
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
                isLoading: state.buttonIsLoading,
                text: Strings.confirmAndSubmitOrder,
                onPressed: () => coinTabCubit.submit(type: type),
                borderRadius: Dimens.standard30,
                color: AppColors.yellow.shade500,
                textColor: AppColors.nature.shade900,
              ),
              const SizedBox(height: Dimens.standard64),
            ],
          ),
        ),
      );
}
