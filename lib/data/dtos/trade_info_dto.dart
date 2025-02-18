import 'package:equatable/equatable.dart';

abstract class TradeInfoDTO extends Equatable {
  final int id;
  final String title;
  final bool buyStatus;
  final bool sellStatus;
  final String buyPrice;
  final String sellPrice;

  const TradeInfoDTO({
    required this.id,
    required this.title,
    required this.buyStatus,
    required this.sellStatus,
    required this.buyPrice,
    required this.sellPrice,
  });

  bool get isGold => this is GoldTradeInfoDTO;

  bool get isCoin => this is CoinTradeInfoDTO;

  String getBuyPrice({required bool isVIP}){
    if(this is GoldTradeInfoDTO && isVIP){
      return (this as GoldTradeInfoDTO).vipBuyPrice;
    }
    return buyPrice;
  }

  String getSellPrice({required bool isVIP}){
    if(this is GoldTradeInfoDTO && isVIP){
      return (this as GoldTradeInfoDTO).vipSellPrice;
    }
    return sellPrice;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        buyStatus,
        sellStatus,
        buyPrice,
        sellPrice,
      ];
}

class GoldTradeInfoDTO extends TradeInfoDTO {
  final String buyPriceGheram;
  final String sellPriceGheram;
  final String vipBuyPrice;
  final String vipSellPrice;
  final String vipBuyPriceGheram;
  final String vipSellPriceGheram;

  String getBuyPriceGheram({required bool isVIP}) => isVIP ? vipBuyPriceGheram : buyPriceGheram;

  String getSellPriceGheram({required bool isVIP}) => isVIP ? vipSellPriceGheram : sellPriceGheram;

  const GoldTradeInfoDTO({
    required super.id,
    required super.title,
    required super.buyStatus,
    required super.sellStatus,
    required super.buyPrice,
    required super.sellPrice,
    required this.buyPriceGheram,
    required this.sellPriceGheram,
    required this.vipBuyPrice,
    required this.vipSellPrice,
    required this.vipBuyPriceGheram,
    required this.vipSellPriceGheram,
  });

  factory GoldTradeInfoDTO.fromJson(Map<String, dynamic> json) {
    return GoldTradeInfoDTO(
      id: json['id'],
      title: json['title'],
      buyStatus: json['buy_status'],
      sellStatus: json['sell_status'],
      buyPrice: json['buy_price'],
      sellPrice: json['sell_price'],
      buyPriceGheram: json['buy_price_gheram'] ?? '',
      sellPriceGheram: json['sell_price_gheram'] ?? '',
      vipBuyPrice: json['vip_buy_price'],
      vipSellPrice: json['vip_sell_price'],
      vipBuyPriceGheram: json['vip_buy_price_gheram'],
      vipSellPriceGheram: json['vip_sell_price_gheram'],
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    buyStatus,
    sellStatus,
    buyPrice,
    sellPrice,
    buyPriceGheram,
    sellPriceGheram,
    vipBuyPrice,
    vipSellPrice,
    vipBuyPriceGheram,
    vipSellPriceGheram,
  ];
}

class CoinTradeInfoDTO extends TradeInfoDTO {
  final String icon;

  const CoinTradeInfoDTO({
    required super.id,
    required super.title,
    required super.buyStatus,
    required super.sellStatus,
    required super.buyPrice,
    required super.sellPrice,
    required this.icon,
  });

  factory CoinTradeInfoDTO.fromJson(Map<String, dynamic> json) {
    return CoinTradeInfoDTO(
      id: json['id'],
      title: json['title'],
      buyStatus: json['buy_status'] == '1',
      sellStatus: json['sell_status'] == '1',
      buyPrice: json['buy_price'].toString(),
      sellPrice: json['sell_price'].toString(),
      icon: json['icon'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    buyStatus,
    sellStatus,
    buyPrice,
    sellPrice,
    icon,
  ];
}
