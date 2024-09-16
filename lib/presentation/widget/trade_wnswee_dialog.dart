import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/core/utils/extensions.dart';
import 'package:deniz_gold/data/dtos/coin_trades_dto.dart';
import 'package:deniz_gold/data/enums.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/key_value.dart';
import 'package:deniz_gold/presentation/widget/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/app_notification_handler.dart';

class TradeAnswerDialog extends StatelessWidget {
  final TradeResultNotificationEvent data;

  const TradeAnswerDialog({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSuccessful = data.status == 1;
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
              text: Strings.understand,
              onPressed: () => context.pop(),
              color: AppColors.nature.shade50,
            ),
            const SizedBox(height: Dimens.standard12),
            AppButton(
              onPressed: () {
                context.pop();
                showSupportBottomSheet(context: context);
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
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(Dimens.standard16))),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: Dimens.standard53,
            height: Dimens.standard53,
            padding: const EdgeInsets.all(Dimens.standard16),
            decoration:
            BoxDecoration(color: AppColors.yellow, shape: BoxShape.circle),
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
            textStyle: AppTextStyle.title3,
          ),
          const SizedBox(height: Dimens.standard24),
          Row(
            children: [
              AppText(
                '${data.buyAndSellType == BuyAndSellType.buy ? 'خرید':'فروش'} ${data.trade_name}',
                textStyle: AppTextStyle.body4,
              ),
              const Spacer(),
              AppText(
                Strings.tradeType_,
                textStyle: AppTextStyle.body4,
                color: AppColors.nature.shade900,
              ),
            ],
          ),
          const SizedBox(height: Dimens.standard8),
          Row(
            children: [
              AppText(
                "${data.mazaneh.clearCommas().numberFormat()} ${Strings.toman}",
                textStyle: AppTextStyle.body5,
              ),
              const Spacer(),
              AppText(
                Strings.mazane,
                textStyle: AppTextStyle.body4,
                color: AppColors.nature.shade900,
              ),
            ],
          ),
          const SizedBox(height: Dimens.standard8),
          Row(
            children: [
              AppText(
                "${data.value} ${data.coinAndGoldType == CoinAndGoldType.gold ? Strings.geram : 'عدد'}",
                textStyle: AppTextStyle.body4,
              ),
              const Spacer(),
              AppText(
                data.coinAndGoldType == CoinAndGoldType.gold ? Strings.requestedWeight : 'تعداد',
                textStyle: AppTextStyle.body4,
                color: AppColors.nature.shade900,
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: Dimens.standard12),
          Row(
            children: [
              AppText(
                "${data.totalPrice.clearCommas().numberFormat()} ${Strings.toman}",
                textStyle: AppTextStyle.body4,
              ),
              const Spacer(),
              AppText(
                Strings.tradeTotalPrice,
                textStyle: AppTextStyle.body4,
                color: AppColors.nature.shade900,
              ),
            ],
          ),
          const SizedBox(height: Dimens.standard28),
          AppButton(
            text: Strings.understand,
            onPressed: () => context.pop(),
            color: AppColors.green,
          ),
          const SizedBox(height: Dimens.standard12),
        ]));
  }
}
