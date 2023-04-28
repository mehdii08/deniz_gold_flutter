import 'package:equatable/equatable.dart';
import 'package:deniz_gold/data/dtos/price_dto.dart';

class HomeScreenDataDTO extends Equatable {
  final String buyPrice;
  final String sellPrice;
  final String goldOns;
  final String goldGheram;
  final String goldWorld;
  final String rialBalance;
  final String goldBalance;
  final String todayHighPrice;
  final String todayLowPrice;
  final List<PriceDTO>? priceHistories;
  final bool accountingStatus;

  const HomeScreenDataDTO({
    required this.buyPrice,
    required this.sellPrice,
    required this.goldOns,
    required this.goldGheram,
    required this.goldWorld,
    required this.rialBalance,
    required this.goldBalance,
    required this.todayHighPrice,
    required this.todayLowPrice,
    required this.priceHistories,
    required this.accountingStatus,
  });

  factory HomeScreenDataDTO.fromJson(Map<String, dynamic> json) => HomeScreenDataDTO(
        buyPrice: json['buy_price'] == 0 ? "0" : json['buy_price'],
        sellPrice: json['sell_price'] == 0 ? "0" : json['sell_price'],
        goldOns: json['gold_ons'] == 0 ? "0" : json['gold_ons'],
        goldGheram: json['gold_gheram'] == 0 ? "0" : json['gold_gheram'],
        goldWorld: json['gold_world'] == 0 ? "0" : json['gold_world'],
        rialBalance: json['rial_balance'] == 0 ? "0" : json['rial_balance'],
        goldBalance: json['gold_balance'] == 0 ? "0" : json['gold_balance'],
        todayHighPrice: json['today_high_price'] == 0 ? "0" : json['today_high_price'],
        todayLowPrice: json['today_low_price'] == 0 ? "0" : json['today_low_price'],
        priceHistories: json['price_histories'] == null ? null : json['price_histories'].length == 0 ? [] : List<PriceDTO>.from(json['price_histories'].map((e) => PriceDTO.fromJson(e)).toList()),
        accountingStatus: json['accounting_status'],
      );

  @override
  List<Object?> get props => [
        buyPrice,
        sellPrice,
        goldOns,
        goldGheram,
        goldWorld,
        rialBalance,
        goldBalance,
        todayHighPrice,
        todayLowPrice,
        priceHistories,
        accountingStatus,
      ];

  HomeScreenDataDTO update(HomeScreenDataDTO newData){
    DateTime now = DateTime.now();
    priceHistories?.add(PriceDTO(buyPrice: newData.buyPrice, sellPrice: newData.sellPrice, time: '${now.hour}:${now.minute}'));
    return HomeScreenDataDTO(
      buyPrice: newData.buyPrice,
      sellPrice: newData.sellPrice,
      goldOns: newData.goldOns,
      goldGheram: newData.goldGheram,
      goldWorld: newData.goldWorld,
      rialBalance: newData.rialBalance,
      goldBalance: newData.goldBalance,
      todayHighPrice: newData.todayHighPrice,
      todayLowPrice: newData.todayLowPrice,
      priceHistories : priceHistories,
      accountingStatus: newData.accountingStatus,
    );
  }
}
