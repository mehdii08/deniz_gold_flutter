import 'dart:convert';

import 'package:deniz_gold/data/dtos/havale_dto.dart';
import 'package:deniz_gold/data/dtos/home_screen_data_dto.dart';
import 'package:deniz_gold/data/enums.dart';

class AppNotificationEvent {
  final String type;

  AppNotificationEvent({
    required this.type,
  });
}

const String tradeResultNotificationType = "trade_result";
const String homeDataNotificationType = "home_data";
const String botStatusNotificationType = "logo_data";
const String havalehStatusNotificationType = "havaleh_result";

class TradeResultNotificationEvent extends AppNotificationEvent {
  final int requestId;
  final int status;
  final int? totalPrice;
  final int? mazaneh;
  final String? weight;
  final BuyAndSellType buyAndSellType;
  final CoinAndGoldType coinAndGoldType;

  TradeResultNotificationEvent({
    required String type,
    required this.requestId,
    required this.status,
    required this.buyAndSellType,
    required this.coinAndGoldType,
    this.totalPrice,
    this.mazaneh,
    this.weight,
  }) : super(type: type);

  factory TradeResultNotificationEvent.fromJson(Map<String, dynamic> json) {
    final data = jsonDecode(json['data']);
    return TradeResultNotificationEvent(
      type: json['type'],
      requestId: data['request_id'],
      status: data['status'],
      buyAndSellType: BuyAndSellType.fromCode(data['type']),
      coinAndGoldType: CoinAndGoldType.fromCode(data['trade_type']),
      totalPrice: data['total_price'],
      mazaneh: data['mazaneh'],
      weight: data['weight'].toString(),
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

  factory HomeDataNotificationEvent.fromJson(Map<String, dynamic> json) =>
      HomeDataNotificationEvent(
        type: json['type'],
        data: HomeScreenDataDTO.fromJson(jsonDecode(json['data'])),
      );
}

class BotStatusDataNotificationEvent extends AppNotificationEvent {
  final String logo;
  final String botStatus;

  BotStatusDataNotificationEvent({
    required String type,
    required this.logo,
    required this.botStatus,
  }) : super(type: type);

  factory BotStatusDataNotificationEvent.fromJson(Map<String, dynamic> json) {
    final data = jsonDecode(json['data']);
    return BotStatusDataNotificationEvent(
      type: json['type'],
      logo: data['logo'],
      botStatus: data['bot_status'],
    );
  }
}
