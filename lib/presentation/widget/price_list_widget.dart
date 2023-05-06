import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:deniz_gold/data/dtos/price_dto.dart';

class PriceListWidget extends StatelessWidget {
  final PriceDTO price;

  const PriceListWidget({
    Key? key,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(
          price.buyPrice.toString().numberFormat(),
          textAlign: TextAlign.start,
              style: AppTextStyle.button5.copyWith(color: AppColors.nature.shade900),
        )),
        Expanded(
            child: Text(
          price.sellPrice.toString().numberFormat(),
          textAlign: TextAlign.center,
          style: AppTextStyle.button5.copyWith(color: AppColors.nature.shade900),
        )),
        Expanded(
            child: Text(
          price.time,
          textAlign: TextAlign.end,
          style: AppTextStyle.body5.copyWith(color: AppColors.nature.shade700),
        )),
      ],
    );
  }
}
