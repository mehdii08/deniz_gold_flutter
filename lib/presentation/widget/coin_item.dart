import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/core/utils/extensions.dart';
import 'package:deniz_gold/data/dtos/coin_dto.dart';
import 'package:deniz_gold/presentation/blocs/coin_shop/coin_shop_screen_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoinItem extends StatelessWidget {
  final CoinDTO coin;
  final bool isSell;
  final int count;

  const CoinItem({
    Key? key,
    required this.coin,
    required this.isSell,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimens.standard8),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.all(Radius.circular(Dimens.standard12)),
          border: Border.all(width: Dimens.standard1, color: AppColors.nature.shade100)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.standard12, vertical: Dimens.standard16),
            margin: const EdgeInsets.all(Dimens.standard4),
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.all(Radius.circular(Dimens.standard4)),
            ),
            child: Row(children: [
              AppText(
                Strings.tomanInParanteses,
                textStyle: AppTextStyle.button5,
                color: AppColors.nature,
              ),
              const SizedBox(width: Dimens.standard4),
              AppText(
                isSell ? coin.sellPrice.numberFormat() : coin.buyPrice.numberFormat(),
                textStyle: AppTextStyle.subTitle3,
                color: AppColors.nature.shade900,
              ),
              const Spacer(),
              AppText(
                coin.title,
                textStyle: AppTextStyle.body4,
                color: AppColors.nature.shade700,
              ),
            ],),
          ),
          const SizedBox(height: Dimens.standard12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleIcon(
                icon: 'assets/images/negative.png',
                onTap: count > 0 ? () => context.read<CoinTabCubit>().decrease(id: coin.id) : null,
              ),
              Row(
                children: [
                  AppText(
                    Strings.count,
                    textStyle: AppTextStyle.body5,
                    color: AppColors.nature,
                  ),
                  const SizedBox(width: Dimens.standard4),
                  AppText(
                    count.toString(),
                    textStyle: AppTextStyle.body3,
                  ),
                ],
              ),
              CircleIcon(
                icon: 'assets/images/plus.png',
                onTap: () => context.read<CoinTabCubit>().increase(id: coin.id),
              ),
            ],
          ),
          const SizedBox(height: Dimens.standard12),
        ],
      ),
    );
  }
}
