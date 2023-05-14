import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/data/dtos/transaction_dto.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionItem extends StatelessWidget {
  final TransactionDTO transaction;

  const TransactionItem({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: Dimens.standard12),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    AppText(
                      '${transaction.date} - ${transaction.time}',
                      textStyle: AppTextStyle.body5,
                      color: AppColors.nature.shade600,
                    ),
                    const Spacer(),
                    AppText(
                      "replace me",
                      textStyle: AppTextStyle.subTitle4,
                    ),
                  ],
                ),
                const SizedBox(height: Dimens.standard16),
                AppText(
                  transaction.title,
                  textStyle: AppTextStyle.body5,
                  color: AppColors.nature.shade700,
                ),
              ],
            ),
          ),
          const SizedBox(width: Dimens.standard16),
          Padding(
            padding: const EdgeInsets.only(top: Dimens.standard8),
            child: SvgPicture.asset(
              "assets/images/plus_circle.svg",
              // "assets/images/negative_circle.svg",//todo
              width: Dimens.standard15,
              fit: BoxFit.fitWidth,
              color: AppColors.green,
              // color: AppColors.red,//todo
            ),
          )
        ],
      ),
      const SizedBox(height: Dimens.standard12),
      Divider(
        color: AppColors.nature.shade50,
      )
    ],
  );
}