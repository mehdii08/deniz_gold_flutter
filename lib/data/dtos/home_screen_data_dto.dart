import 'package:deniz_gold/data/dtos/home_price_dto.dart';
import 'package:deniz_gold/data/dtos/price_dto.dart';
import 'package:equatable/equatable.dart';

import 'brief_coin_dto.dart';

class HomeScreenDataDTO extends Equatable {
  final HomePriceDTO buyPrice;
  final HomePriceDTO sellPrice;
  final HomePriceDTO goldOns;
  final HomePriceDTO goldGheram;
  final HomePriceDTO goldWorld;
  final HomePriceDTO todayHighPrice;
  final HomePriceDTO todayLowPrice;
  final List<PriceDTO>? priceHistories;
  final bool accountingStatus;
  final BriefCoinDTO? coin;

  const HomeScreenDataDTO({
    required this.buyPrice,
    required this.sellPrice,
    required this.goldOns,
    required this.goldGheram,
    required this.goldWorld,
    required this.todayHighPrice,
    required this.todayLowPrice,
    required this.priceHistories,
    required this.accountingStatus,
    required this.coin,
  });

  factory HomeScreenDataDTO.fromJson(Map<String, dynamic> json) => HomeScreenDataDTO(
        buyPrice: HomePriceDTO.fromJson(json['buy_price']),
        sellPrice: HomePriceDTO.fromJson(json['sell_price']),
        goldOns: HomePriceDTO.fromJson(json['gold_ons']),
        goldGheram: HomePriceDTO.fromJson(json['gold_gheram']),
        goldWorld: HomePriceDTO.fromJson(json['gold_world']),
        todayHighPrice: HomePriceDTO.fromJson(json['today_high_price']),
        todayLowPrice: HomePriceDTO.fromJson(json['today_low_price']),
        priceHistories: json['price_histories'] == null
            ? null
            : json['price_histories'].length == 0
                ? []
                : List<PriceDTO>.from(json['price_histories'].map((e) => PriceDTO.fromJson(e)).toList()),
        accountingStatus: json['accounting_status'] ?? false,
        coin: json['coin'] != null ? BriefCoinDTO.fromJson(json['coin']) : null,
      );

  @override
  List<Object?> get props => [
        buyPrice,
        sellPrice,
        goldOns,
        goldGheram,
        goldWorld,
        todayHighPrice,
        todayLowPrice,
        priceHistories,
        accountingStatus,
    coin,
      ];

  HomeScreenDataDTO update(HomeScreenDataDTO newData) {
    DateTime now = DateTime.now();
    priceHistories?.add(PriceDTO(
        buyPrice: newData.buyPrice.price.toString(),
        sellPrice: newData.sellPrice.price.toString(),
        time: '${now.hour}:${now.minute}'));
    return HomeScreenDataDTO(
      buyPrice: newData.buyPrice,
      sellPrice: newData.sellPrice,
      goldOns: newData.goldOns,
      goldGheram: newData.goldGheram,
      goldWorld: newData.goldWorld,
      todayHighPrice: newData.todayHighPrice,
      todayLowPrice: newData.todayLowPrice,
      priceHistories: priceHistories,
      accountingStatus: newData.accountingStatus,
      coin: coin,
    );
  }
}
