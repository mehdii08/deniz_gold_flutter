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

class TradeAnswerDialog extends StatelessWidget {
  final BuyAndSellType buyAndSellType;
  final CoinAndGoldType coinAndGoldType;
  final String status;
  final String? totalPrice;
  final String? mazaneh;
  final String? weight;
  final List<CoinTradesDTO>? coins;

  const TradeAnswerDialog({
    Key? key,
    required this.buyAndSellType,
    required this.coinAndGoldType,
    required this.status,
    this.totalPrice,
    this.mazaneh,
    this.weight,
    this.coins,
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
                getTypeString(),
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
          if (coins != null)
            ...?coins
                ?.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: Dimens.standard8),
                      child: KeyValue(title: e.title, value: '${e.count} عدد'),
                    ))
                .toList(),
          if (mazaneh != null && mazaneh?.isNotEmpty == true && mazaneh != 'null') ...[
            const SizedBox(height: Dimens.standard8),
            Row(
              children: [
                if (mazaneh != null && mazaneh?.isNotEmpty == true && mazaneh != 'null')
                  AppText(
                    "${mazaneh.clearCommas().numberFormat()} ${Strings.toman}",
                    textStyle: AppTextStyle.body4,
                  ),
                const Spacer(),
                AppText(
                  Strings.mazane,
                  textStyle: AppTextStyle.body4,
                  color: AppColors.nature.shade700,
                ),
              ],
            ),
          ],
          if (weight != null && weight?.isNotEmpty == true && weight != 'null') ...[
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
          ],
          const Divider(),
          const SizedBox(height: Dimens.standard12),
          Row(
            children: [
              AppText(
                "${totalPrice.clearCommas().numberFormat()} ${Strings.toman}",
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

  String getTypeString() {
    if (buyAndSellType == BuyAndSellType.buy) {
      return coinAndGoldType == CoinAndGoldType.gold ? Strings.buyGold : Strings.buyCoin;
    } else {
      return coinAndGoldType == CoinAndGoldType.gold ? Strings.sellGold : Strings.sellCoin;
    }
  }
}
