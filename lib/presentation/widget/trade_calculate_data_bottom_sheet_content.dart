import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/core/utils/extensions.dart';
import 'package:deniz_gold/data/dtos/trade_calculate_response_dto.dart';
import 'package:deniz_gold/data/dtos/trade_submit_response_dto.dart';
import 'package:deniz_gold/presentation/blocs/trade/trade_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TradeCalculateDataBottomSheetContent extends StatelessWidget {
  final TradeCalculateResponseDTO data;
  final bool isSell;
  final VoidCallback onConfirmClicked;
  final Function(TradeSubmitResponseDTO) onTradeSubmitted;
  final TradeCubit tradeCubit;

  const TradeCalculateDataBottomSheetContent({
    Key? key,
    required this.data,
    required this.isSell,
    required this.onConfirmClicked,
    required this.onTradeSubmitted,
    required this.tradeCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocConsumer<TradeCubit, TradeState>(
    bloc: tradeCubit,
    listener: (context, state) {
      if (state is TradeSubmited) {
        onTradeSubmitted.call(state.data);
      }
    },
    builder: (context, state) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.standard16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Dimens.standard20),
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
                "${data.mazaneh.clearCommas().numberFormat()} ${Strings.toman}",
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
                "${data.weight} ${Strings.geram}",
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
                "${data.totalPrice.numberFormat()} ${Strings.toman}",
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
            isLoading: state is TradeLoading && state.submitLoading,
            text: Strings.confirmAndSubmitOrder,
            onPressed: onConfirmClicked,
          ),
          const SizedBox(height: Dimens.standard64),
        ],
      ),
    ),
  );
}