import 'dart:convert';

import 'package:deniz_gold/data/dtos/coin_trades_dto.dart';
import 'package:deniz_gold/data/dtos/havale_dto.dart';
import 'package:deniz_gold/data/dtos/home_screen_data_dto.dart';
import 'package:deniz_gold/data/enums.dart';

import '../../data/dtos/trade_info_dto.dart';

class AppNotificationEvent {
  final String type;

  AppNotificationEvent({
    required this.type,
  });
}

const String tradeResultNotificationType = "trade_result";
const String homeDataNotificationType = "home_data";
const String coinsPriceNotificationType = "coins_price";
const String botStatusNotificationType = "logo_data";
const String havalehStatusNotificationType = "havaleh_result";

class TradeResultNotificationEvent extends AppNotificationEvent {
  final int requestId;
  final int status;
  final String? totalPrice;
  final String? mazaneh;
  final String? value;
  final BuyAndSellType buyAndSellType;
  final CoinAndGoldType coinAndGoldType;
  final String? trade_name;

  TradeResultNotificationEvent({
    required String type,
    required this.requestId,
    required this.status,
    required this.buyAndSellType,
    required this.coinAndGoldType,
    this.totalPrice,
    this.mazaneh,
    this.value,
    this.trade_name,
  }) : super(type: type);

  factory TradeResultNotificationEvent.fromJson(Map<String, dynamic> json) {
    final data = json['data'] != null ? jsonDecode(json['data']) : json;
    return TradeResultNotificationEvent(
      type: tradeResultNotificationType,
      requestId: data['request_id'],
      status: data['status'],
      buyAndSellType: BuyAndSellType.fromCode(data['type']),
      coinAndGoldType: CoinAndGoldType.fromCode(data['trade_type']),
      totalPrice: data['total_price'].toString(),
      mazaneh: data['mazaneh'].toString(),
      value: data['value'].toString(),
      trade_name: data['trade_name'],
    );
  }
}

class CoinsPriceNotificationEvent extends AppNotificationEvent {
  final List<CoinTradeInfoDTO> coins;

  CoinsPriceNotificationEvent({
    required String type,
    required this.coins,
  }) : super(type: type);

  factory CoinsPriceNotificationEvent.fromJson(Map<String, dynamic> json) {
    final data = jsonDecode(json['data']);
    return CoinsPriceNotificationEvent(
      type: json['type'],
      coins: List<CoinTradeInfoDTO>.from(data.map((e) => CoinTradeInfoDTO.fromJson(e)).toList()),
    );
  }
}

class HavalehStatusNotificationEvent extends AppNotificationEvent {
  final HavaleDTO havaleh;

  HavalehStatusNotificationEvent({
    required String type,
    required this.havaleh,
  }) : super(type: type);

  factory HavalehStatusNotificationEvent.fromJson(Map<String, dynamic> json) {
    final data = jsonDecode(json['data']);
    return HavalehStatusNotificationEvent(
      type: json['type'],
      havaleh: HavaleDTO.fromJson(data),
    );
  }
}

class HomeDataNotificationEvent extends AppNotificationEvent {
  final HomeScreenDataDTO data;

  HomeDataNotificationEvent({
    required String type,
    required this.data,
  }) : super(type: type);

  factory HomeDataNotificationEvent.fromJson(Map<String, dynamic> json) => HomeDataNotificationEvent(
        type: json['type'],
        data: HomeScreenDataDTO.fromJson(jsonDecode(json['data'])),
      );
}

class BotStatusDataNotificationEvent extends AppNotificationEvent {
  final String logo;
  final String botStatus;
  final String? coinStatus;

  BotStatusDataNotificationEvent({
    required String type,
    required this.logo,
    required this.botStatus,
    required this.coinStatus,
  }) : super(type: type);

  factory BotStatusDataNotificationEvent.fromJson(Map<String, dynamic> json) {
    final data = jsonDecode(json['data']);
    return BotStatusDataNotificationEvent(
      type: json['type'],
      logo: data['logo'],
      botStatus: data['bot_status'],
      coinStatus: data['coin_status'] ?? '1',
    );
  }
}
