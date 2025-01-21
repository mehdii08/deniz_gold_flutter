import 'package:deniz_gold/data/dtos/price_dto.dart';
import 'package:equatable/equatable.dart';


import 'trade_info_dto.dart';

class HomeScreenDataDTO extends Equatable {
  final List<CoinTradeInfoDTO> coins;
  final List<GoldTradeInfoDTO> trades;
  // final HomePriceDTO goldOns;
  // final HomePriceDTO goldGheram;
  // final HomePriceDTO goldWorld;
  // final HomePriceDTO todayHighPrice;
  // final HomePriceDTO todayLowPrice;
  final List<PriceDTO>? priceHistories;
  final bool accountingStatus;
  final bool moltenTradeStatus;
  final bool coinTradeStatus;
  final String? message;

  const HomeScreenDataDTO({
    required this.coins,
    required this.trades,
    // required this.goldOns,
    // required this.goldGheram,
    // required this.goldWorld,
    // required this.todayHighPrice,
    // required this.todayLowPrice,
    required this.priceHistories,
    required this.accountingStatus,
    required this.moltenTradeStatus,
    required this.coinTradeStatus,
    required this.message,
  });

  factory HomeScreenDataDTO.fromJson(Map<String, dynamic> json) => HomeScreenDataDTO(
    coins: List<CoinTradeInfoDTO>.from(json['coins'].map((e) => CoinTradeInfoDTO.fromJson(e)).toList()),
    trades: List<GoldTradeInfoDTO>.from(json['trades'].map((e) => GoldTradeInfoDTO.fromJson(e)).toList()),
        // goldOns: HomePriceDTO.fromJson(json['gold_ons']),
        // goldGheram: HomePriceDTO.fromJson(json['gold_gheram']),
        // goldWorld: HomePriceDTO.fromJson(json['gold_world']),
        // todayHighPrice: HomePriceDTO.fromJson(json['today_high_price']),
        // todayLowPrice: HomePriceDTO.fromJson(json['today_low_price']),
        priceHistories: json['price_histories'] == null
            ? null
            : json['price_histories'].length == 0
                ? []
                : List<PriceDTO>.from(json['price_histories'].map((e) => PriceDTO.fromJson(e)).toList()),
        accountingStatus: json['accounting_status'] ?? false,
        moltenTradeStatus: json['molten_trade_status']  == '1',
        coinTradeStatus: json['coin_trade_status']  == '1',
        message: json['message'],
      );

  @override
  List<Object?> get props => [
        coins,
        trades,
        // goldOns,
        // goldGheram,
        // goldWorld,
        // todayHighPrice,
        // todayLowPrice,
        priceHistories,
        accountingStatus,
        message,
    moltenTradeStatus,
    coinTradeStatus,
      ];

  HomeScreenDataDTO update(HomeScreenDataDTO newData) {
    // DateTime now = DateTime.now();
    // priceHistories?.insert(0,PriceDTO(
    //     buyPrice: newData.buyPrice.price.toString(),
    //     sellPrice: newData.sellPrice.price.toString(),
    //     time: '${now.hour}:${now.minute}'));
    return HomeScreenDataDTO(
      coins: newData.coins,
      trades: newData.trades,
      // goldOns: newData.goldOns,
      // goldGheram: newData.goldGheram,
      // goldWorld: newData.goldWorld,
      // todayHighPrice: newData.todayHighPrice,
      // todayLowPrice: newData.todayLowPrice,
      priceHistories: newData.priceHistories,
      accountingStatus: newData.accountingStatus,
      message: message,
      moltenTradeStatus: newData.moltenTradeStatus,
      coinTradeStatus: newData.coinTradeStatus,
    );
  }

  HomeScreenDataDTO updateCoin(List<CoinTradeInfoDTO> coins) {
    return HomeScreenDataDTO(
      coins: coins,
      trades: trades,
      // goldOns: goldOns,
      // goldGheram: goldGheram,
      // goldWorld: goldWorld,
      // todayHighPrice: todayHighPrice,
      // todayLowPrice: todayLowPrice,
      priceHistories: priceHistories,
      accountingStatus: accountingStatus,
      message: message,
      moltenTradeStatus: moltenTradeStatus,
      coinTradeStatus: coinTradeStatus,
    );
  }
}
//test comment