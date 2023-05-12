import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/core/utils/extensions.dart';
import 'package:deniz_gold/data/dtos/trade_dto.dart';
import 'package:deniz_gold/data/enums.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';

class TradeItem extends StatelessWidget {
  final TradeDTO trade;

  const TradeItem({
    Key? key,
    required this.trade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: Dimens.standard12),
      Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    AppText(
                      trade.totalPrice.toString().numberFormat(),
                      textStyle: AppTextStyle.subTitle3,
                    ),
                    const Spacer(),
                    AppText(
                      trade.typeString,
                      textStyle: AppTextStyle.subTitle4,
                      color: trade.type == TradeType.sell ? AppColors.red : AppColors.green,
                    ),
                  ],
                ),
                Row(
                  children: [
                    AppText(
                      Strings.toman,
                      textStyle: AppTextStyle.body6,
                      color: AppColors.nature.shade600,
                    ),
                    const Spacer(),
                    AppText(
                      '${trade.faDate} - ${trade.faTime}',
                      textStyle: AppTextStyle.body5,
                      color: AppColors.nature.shade600,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: Dimens.standard16),
          Container(
            width: Dimens.standard4,
            height: Dimens.standard56,
            color: trade.type == TradeType.sell ? AppColors.red : AppColors.green,
          )
        ],
      ),
      const SizedBox(height: Dimens.standard12),
      Row(
        children: [
          AppText(
            Strings.eachGeramPrice,
            textStyle: AppTextStyle.body6,
            color: AppColors.nature.shade600,
          ),
          const Spacer(),
          AppText(
            Strings.weight,
            textStyle: AppTextStyle.body6,
            color: AppColors.nature.shade600,
          ),
          const SizedBox(width: Dimens.standard20),
        ],
      ),
      Row(
        children: [
          AppText(
            trade.mazaneh.toString().numberFormat(),
            textStyle: AppTextStyle.body4,
            color: AppColors.nature.shade700,
          ),
          const Spacer(),
          AppText(
            trade.weight.toString(),
            textStyle: AppTextStyle.body4,
            color: AppColors.nature.shade700,
          ),
          const SizedBox(width: Dimens.standard20),
        ],
      ),
      const SizedBox(height: Dimens.standard12),
      Divider(
        color: AppColors.nature.shade50,
      )
    ],
  );
}