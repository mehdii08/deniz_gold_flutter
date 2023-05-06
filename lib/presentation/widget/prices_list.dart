import 'package:flutter/material.dart';
import 'package:deniz_gold/data/dtos/price_dto.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/price_list_widget.dart';

class PricesList extends StatelessWidget {
  final List<PriceDTO> prices;

  const PricesList({
    Key? key,
    required this.prices,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(prices.isNotEmpty)
          ...prices
              .map(
                (e) => Column(
                  children: [
                    PriceListWidget(price: e),
                    const SizedBox(height: Dimens.standard12),
                  ],
                ),
          )
              .toList()
          else
            ...[
              const SizedBox(height: Dimens.standard6X),
              const EmptyListPlaceHolder()
            ],
          const SizedBox(height: 130),
        ],
      ),
    );
  }
}

class EmptyListPlaceHolder extends StatelessWidget {
  const EmptyListPlaceHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Image.asset('assets/images/'),
        Text(Strings.listIsEmpty, style: Theme.of(context).textTheme.labelMedium,),
      ],
    );
  }
}
