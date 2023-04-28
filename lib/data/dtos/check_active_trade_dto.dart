import 'package:equatable/equatable.dart';
import 'package:deniz_gold/data/dtos/trade_dto.dart';

class CheckActiveTradeDTO extends Equatable {
  final bool hasActiveTrade;
  final TradeDTO? trade;

  const CheckActiveTradeDTO({
    required this.hasActiveTrade,
    required this.trade,
  });

  factory CheckActiveTradeDTO.fromJson(Map<String, dynamic> json) => CheckActiveTradeDTO(
        hasActiveTrade: json['has_active_trade'],
        trade: json['trade'] != null ? TradeDTO.fromJson(json['trade']) : null,
      );

  @override
  List<Object?> get props => [hasActiveTrade, trade];
}
