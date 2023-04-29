import 'dart:convert';

import 'package:deniz_gold/data/dtos/home_screen_data_dto.dart';

class AppNotificationEvent{
  final String type;

  AppNotificationEvent({
    required this.type,
  });

}

const String tradeResultNotificationType = "trade_result";
const String homeDataNotificationType = "home_data";
const String botStatusNotificationType = "logo_data";

class TradeResultNotificationEvent extends AppNotificationEvent{
  final int requestId;
  final String status;
  final String? totalPrice;
  final String? mazaneh;
  final String? weight;

  TradeResultNotificationEvent({
    required String type,
    required this.requestId,
    required this.status,
    this.totalPrice,
    this.mazaneh,
    this.weight,
  }) : super(type: type);

  factory TradeResultNotificationEvent.fromJson(Map<String, dynamic> json) {
    final data = jsonDecode(json['data']);
    return TradeResultNotificationEvent(
      type: json['type'],
      requestId: data['request_id'],
      status: data['status'].toString(),
      totalPrice: data['total_price'],
      mazaneh: data['mazaneh'],
      weight: data['weight'].toString(),
    );
  }

}

class HomeDataNotificationEvent extends AppNotificationEvent{
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

class BotStatusDataNotificationEvent extends AppNotificationEvent{
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