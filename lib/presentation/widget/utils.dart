import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/data/dtos/coin_trade_calculate_response_dto.dart';
import 'package:deniz_gold/data/dtos/coin_trade_submit_response_dto.dart';
import 'package:deniz_gold/data/dtos/trade_calculate_response_dto.dart';
import 'package:deniz_gold/data/dtos/trade_submit_response_dto.dart';
import 'package:deniz_gold/data/enums.dart';
import 'package:deniz_gold/presentation/blocs/coin_shop/coin_shop_screen_cubit.dart';
import 'package:deniz_gold/presentation/blocs/havlehOwner/havaleh_owner_cubit.dart';
import 'package:deniz_gold/presentation/blocs/trade/trade_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/bottom_sheet_header.dart';
import 'package:deniz_gold/presentation/widget/coin_trade_calculate_data_bottom_sheet_content.dart';
import 'package:deniz_gold/presentation/widget/edit_name_sheet_content.dart';
import 'package:deniz_gold/presentation/widget/edit_password_sheet_content.dart';
import 'package:deniz_gold/presentation/widget/support_content.dart';
import 'package:deniz_gold/presentation/widget/trade_answer_waiting_dialog.dart';
import 'package:deniz_gold/presentation/widget/trade_calculate_data_bottom_sheet_content.dart';
import 'package:deniz_gold/presentation/widget/trade_wnswee_dialog.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'coint_detail_content.dart';

showSupportBottomSheet({required BuildContext context}) {
  showModalBottomSheet(
    context: context,
    // enableDrag: true,
    useRootNavigator: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.standard16))),
    builder: (context) => const BottomSheetHeader(
      title: Strings.callToSupport,
      child: SupportSheetContent(),
    ),
  );
}

showHavalehSelectorSelectorBottomSheet({
  required BuildContext context,
  required String? selectedKey,
  required Function(String?, int?) onChange,
}) {
  showModalBottomSheet(
    context: context,
    // enableDrag: true,
    useRootNavigator: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.standard16))),
    builder: (context) => SafeArea(
      child: BottomSheetHeader(
        title: Strings.havaleNazde,
        child: BlocProvider<HavalehOwnerCubit>(
          create: (_) => sl<HavalehOwnerCubit>(),
          child: BlocBuilder<HavalehOwnerCubit, HavalehOwnerState>(builder: (context, state) {
            if (state is HavalehOwnerLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppText(
                        Strings.yourself,
                        textStyle: AppTextStyle.body4,
                      ),
                      const SizedBox(width: Dimens.standard16),
                      Radio(
                        value: null,
                        groupValue: selectedKey,
                        onChanged: (key) {
                          onChange.call(null, null);
                          context.pop();
                        },
                      ),
                    ],
                  ),
                  ...state.selectableItems.keys
                      .map(
                        (key) => Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppText(
                              key,
                              textStyle: AppTextStyle.body4,
                            ),
                            const SizedBox(width: Dimens.standard16),
                            Radio(
                              value: key,
                              groupValue: selectedKey,
                              onChanged: (key) {
                                onChange.call(key, state.selectableItems[key]);
                                context.pop();
                              },
                            ),
                          ],
                        ),
                      )
                      .toList(),
                  const SizedBox(height: Dimens.standard32),
                ],
              );
            }
            return const Padding(
                padding: EdgeInsets.symmetric(vertical: Dimens.standard40), child: CircularProgressIndicator());
          }),
        ),
      ),
    ),
  );
}

showSingleSelectBottomSheet<T>({
  required BuildContext context,
  required String title,
  required Map<String, T> selectableItems,
  required String? selectedKey,
  required Function(String?) onChange,
}) {
  showModalBottomSheet(
    context: context,
    // enableDrag: true,
    useRootNavigator: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.standard16))),
    builder: (context) => BottomSheetHeader(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...selectableItems.keys
              .map(
                (key) => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppText(
                      key,
                      textStyle: AppTextStyle.body4,
                    ),
                    const SizedBox(width: Dimens.standard16),
                    Radio(
                      value: key,
                      groupValue: selectedKey,
                      onChanged: (key) {
                        onChange.call(key);
                        context.pop();
                      },
                    ),
                  ],
                ),
              )
              .toList(),
          const SizedBox(height: Dimens.standard32),
        ],
      ),
    ),
  );
}

showTradeCalculateDataBottomSheet({
  required BuildContext context,
  required TradeCalculateResponseDTO data,
  required bool isSell,
  required VoidCallback onConfirmClicked,
  required Function(TradeSubmitResponseDTO) onTradeSubmitted,
  required TradeCubit tradeCubit,
}) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.standard16))),
    builder: (context) => BottomSheetHeader(
      title: Strings.confirmTradeDetails,
      child: TradeCalculateDataBottomSheetContent(
        data: data,
        isSell: isSell,
        onConfirmClicked: onConfirmClicked,
        onTradeSubmitted: onTradeSubmitted,
        tradeCubit: tradeCubit,
      ),
    ),
  );
}

showCoinTradeCalculateDataBottomSheet({
  required BuildContext context,
  required CoinTradeCalculateResponseDTO data,
  required BuyAndSellType type,
  required VoidCallback onConfirmClicked,
  required Function(TradeSubmitResponseDTO) onTradeSubmitted,
  required CoinTabCubit coinTabCubit,
}) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.standard16))),
    builder: (context) => BottomSheetHeader(
      title: Strings.confirmTradeDetails,
      child: CoinTradeCalculateDataBottomSheetContent(
        data: data,
        type: type,
        onTradeSubmitted: onTradeSubmitted,
        coinTabCubit: coinTabCubit,
      ),
    ),
  );
}

showNameEditBottomSheet({required BuildContext context, required String name, required VoidCallback onNameEdited}) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.standard16))),
    builder: (context) => BottomSheetHeader(
      title: Strings.editFullName,
      child: EditNameSheetContent(
        name: name,
        onNameEdited: onNameEdited,
      ),
    ),
  );
}

showPasswordEditBottomSheet({required BuildContext context}) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.standard16))),
    builder: (context) => const BottomSheetHeader(
      title: Strings.editPassword,
      child: EditPasswordSheetContent(),
    ),
  );
}

showTradeAnswerWaitingDialog({
  required BuildContext context,
  required TradeSubmitResponseDTO data,
  required bool isSell,
  required TradeCubit tradeCubit,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (builderContext) {
      return TradeAnswerWaitingDialog(
        data: data,
        isSell: isSell,
        tradeCubit: tradeCubit,
        onResultReached: (trade) {
          context.pop();
          showTradeAnswerDialog(
            context: context,
            buyAndSellType: trade.buyAndSellType,
            coinAndGoldType: trade.coinAndGoldType,
            status: trade.status.toString(),
            totalPrice: trade.totalPrice.toString(),
            mazaneh: trade.mazaneh.toString(),
            weight: trade.weight,
          );
        },
      );
    },
  );
}

showTradeAnswerDialog({
  required BuildContext context,
  required BuyAndSellType buyAndSellType,
  required CoinAndGoldType coinAndGoldType,
  required String status,
  required String? totalPrice,
  required String? mazaneh,
  required String? weight,
}){
  showDialog(
    context: context,
    builder: (_) => TradeAnswerDialog(
      buyAndSellType: buyAndSellType,
      coinAndGoldType: coinAndGoldType,
      status: status.toString(),
      totalPrice: totalPrice.toString(),
      mazaneh: mazaneh,
      weight: weight,
    ),
  );
}

showCoinTradeAnswerWaitingDialog({
  required BuildContext context,
  required CoinTradeSubmitResponseDTO data,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (builderContext) {
      return CoinTradeAnswerWaitingDialog(
        data: data,
        onResultReached: (trade) {
          context.pop();
          showTradeAnswerDialog(
            context: context,
            buyAndSellType: trade.buyAndSellType,
            coinAndGoldType: trade.coinAndGoldType,
            status: trade.status.toString(),
            totalPrice: trade.totalPrice.toString(),
            mazaneh: trade.mazaneh.toString(),
            weight: trade.weight,
          );
        },
      );
    },
  );
}

showCoinDetailBottomSheet({required BuildContext context, required int id}) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.standard16))),
    builder: (context) => BottomSheetHeader(
      title: Strings.transactionDetails,
      child: CoinDetailContent(
        id: id,
      ),
    ),
  );
}
