import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/core/utils/extensions.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/dtos/coin_trade_dto.dart';
import '../../data/enums.dart';
import 'utils.dart';

class CoinTradeItem extends StatelessWidget {
  final CoinTradeDTO trade;

  const CoinTradeItem({
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
                          trade.type == BuyAndSellType.buy ? Strings.buyCoin : Strings.sellCoin,
                          textStyle: AppTextStyle.subTitle4,
                          color: trade.type == BuyAndSellType.sell ? AppColors.red : AppColors.green,
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
                          trade.faDate,
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
                color: trade.type == BuyAndSellType.sell ? AppColors.red : AppColors.green,
              )
            ],
          ),
          const SizedBox(height: Dimens.standard12),
          Row(
            children: [
              GestureDetector(
                onTap: () => showCoinDetailBottomSheet(context: context, id: trade.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.standard8, vertical: Dimens.standard4),
                  decoration: BoxDecoration(
                      color: AppColors.nature.shade50,
                      borderRadius: const BorderRadius.all(Radius.circular(Dimens.standard24))),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/left.svg',
                        width: Dimens.standard16,
                      ),
                      const SizedBox(width: Dimens.standard8),
                      AppText(
                        Strings.details,
                        textStyle: AppTextStyle.button5,
                        color: AppColors.nature.shade600,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  AppText(
                    Strings.count_,
                    textStyle: AppTextStyle.body6,
                    color: AppColors.nature.shade600,
                  ),
                  AppText(
                    '${trade.count} ${Strings.count}',
                    textStyle: AppTextStyle.body4,
                    color: AppColors.nature.shade700,
                  )
                ],
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
