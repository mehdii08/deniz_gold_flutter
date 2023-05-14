import 'package:deniz_gold/data/enums.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/pages/trade_screen.dart';
import 'package:flutter/material.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/price_widget.dart';
import 'package:go_router/go_router.dart';

class BuyAndSellPrices extends StatelessWidget {
  final String buyPrice;
  final String sellPrice;

  const BuyAndSellPrices({
    Key? key,
    required this.buyPrice,
    required this.sellPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: () => context.goNamed(TradeScreen.route.name!, queryParams: {'is_sell' : "true"}),
            child: PriceWidget(
              title: Strings.sellPriceMesgal,
              price: sellPrice,
              isSell: true,
              changeArrowAlign: IconAlign.left,
            ),
          ),
        ),
        const SizedBox(width: Dimens.standard8),
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: () => context.goNamed(TradeScreen.route.name!, queryParams: {'is_sell' : "false"}),
            child: PriceWidget(
              title: Strings.buyPrice,
              price: buyPrice,
              isSell: false,
              changeArrowAlign: IconAlign.right,
            ),
          ),
        ),
      ],
    );
  }
}