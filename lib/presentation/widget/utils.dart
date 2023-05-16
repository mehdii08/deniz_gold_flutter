import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/data/dtos/trade_calculate_response_dto.dart';
import 'package:deniz_gold/data/dtos/trade_submit_response_dto.dart';
import 'package:deniz_gold/presentation/blocs/auth/authentication_cubit.dart';
import 'package:deniz_gold/presentation/blocs/trade/trade_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/bottom_sheet_header.dart';
import 'package:deniz_gold/presentation/widget/edit_name_sheet_content.dart';
import 'package:deniz_gold/presentation/widget/edit_password_sheet_content.dart';
import 'package:deniz_gold/presentation/widget/support_content.dart';
import 'package:deniz_gold/presentation/widget/trade_calculate_data_bottom_sheet_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

showSupportBottomSheet({required BuildContext context}) {
  final appConfig = context.read<AuthenticationCubit>().getLocalAppConfig();
  if (appConfig != null) {
    showModalBottomSheet(
      context: context,
      // enableDrag: true,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.standard16))),
      builder: (context) => BottomSheetHeader(
        title: Strings.callToSupport,
        child: SupportSheetContent(appConfig: appConfig),
      ),
    );
  }
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppText(
                Strings.all,
                textStyle: AppTextStyle.body4,
              ),
              const SizedBox(width: Dimens.standard16),
              Radio(
                value: null,
                groupValue: selectedKey,
                onChanged: (key) {
                  onChange.call(key);
                  context.pop();
                },
              ),
            ],
          ),
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
