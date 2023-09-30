import 'package:deniz_gold/data/dtos/receipt_dto.dart';
import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:show_network_image/show_network_image.dart';

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReceiptStatusBadge(
                    status: receiptDTO.status,
                    statusText: receiptDTO.statusString,
                  ),
                  const SizedBox(
                    height: Dimens.standard4,
                  ),
                  AppText(
                    "${receiptDTO.date} - ${receiptDTO.time}",
                    textStyle: AppTextStyle.body6,
                  ),
                ],
              ),
              const SizedBox(
                width: Dimens.standard12,
              ),
              GestureDetector(
                onTap: () async {
                  await showDialog(
                  context: context,
                  builder: (_) => ImageDialog(imageUrl: receiptDTO.imageUrl,)
                  );
                },
                child: SizedBox(
                  width: Dimens.standard64,
                  height: Dimens.standard64,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimens.standard8),
                    child: Image.network(
                      receiptDTO.imageUrl,
                      fit: BoxFit.cover,
                      height: Dimens.standard64,
                      width: Dimens.standard64,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: Dimens.standard8,
          ),
          Container(
            height: Dimens.standard1,
            width: double.maxFinite,
            color: AppColors.nature.shade100,
          )
        ],
      );
}

class ReceiptStatusBadge extends StatelessWidget {
  final int status;
  final String statusText;

  const ReceiptStatusBadge({
    Key? key,
    required this.status,
    required this.statusText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(Dimens.standard6),
        decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.all(Radius.circular(Dimens.standard16)),
            color: status == 0
                ? AppColors.nature.shade50
                : AppColors.green.shade50),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText(
              statusText,
              textStyle: AppTextStyle.body6,
            ),
            const SizedBox(width: Dimens.standard6),
            SvgPicture.asset(
              status == 0
                  ? 'assets/images/time_clock.svg'
                  : 'assets/images/checkmark_circle.svg',
              width: Dimens.standard16,
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      );
}
class ImageDialog extends StatelessWidget {
  final String imageUrl;

  const ImageDialog({super.key, required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Image.network(imageUrl),
    );
  }
}
