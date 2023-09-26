import 'package:deniz_gold/data/dtos/receipt_dto.dart';
import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/core/utils/extensions.dart';
import 'package:deniz_gold/data/dtos/receipt_dto.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';

class ReceiptItem extends StatelessWidget {
  final ReceiptDTO receiptDTO;

  const ReceiptItem({
    Key? key,
    required this.receiptDTO,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(
            height: Dimens.standard12,
          ),
          Row(
            children: [
              AppText(
                receiptDTO.price.toString().numberFormat(),
                textStyle: AppTextStyle.subTitle3,
                textDirection: TextDirection.ltr,
                color: AppColors.nature.shade900,
              ),
              const Spacer(),
              Row(
                children: [
                  AppText(
                    receiptDTO.name,
                    textAlign: TextAlign.right,
                    textStyle: AppTextStyle.subTitle4,
                    color: AppColors.nature.shade900,
                  ),
                  AppText(
                    Strings.forName,
                    textStyle: AppTextStyle.body5,
                    color: AppColors.nature.shade600,
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: Dimens.standard4,
          ),
          Row(
            children: [
              AppText(
                Strings.toman,
                textStyle: AppTextStyle.body5,
                color: AppColors.nature.shade600,
              ),
              const Spacer(),
              AppText(
                receiptDTO.date,
                textStyle: AppTextStyle.body5,
                textDirection: TextDirection.ltr,
                color: AppColors.nature.shade600,
              ),
            ],
          ),
          const SizedBox(
            height: Dimens.standard8,
          ),
          AppText(
            Strings.trackingCode,
            textStyle: AppTextStyle.body5,
            color: AppColors.nature.shade600,
          ),
          if (receiptDTO.trackingCode != null)
            AppText(
              receiptDTO.trackingCode!,
              textStyle: AppTextStyle.body3,
              color: AppColors.nature.shade900,
            ),
          const SizedBox(
            height: Dimens.standard12,
          ),
          Container(
            height: Dimens.standard1,
            width: double.maxFinite,
            color: AppColors.nature.shade100,
          )
        ],
      );
}
