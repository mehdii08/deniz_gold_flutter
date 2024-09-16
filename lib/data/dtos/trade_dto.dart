import 'package:deniz_gold/data/dtos/coin_trades_dto.dart';
import 'package:deniz_gold/data/enums.dart';
import 'package:equatable/equatable.dart';

class TradeDTO extends Equatable {
  final int id;
  final BuyAndSellType buyAndSellType;
  final String buyAndSellTypeString;
  final CoinAndGoldType coinAndGoldType;
  final String coinAndGoldTypeString;
  final int status;
  final String statusString;
  final int? mazaneh;
  final int totalPrice;
  final String? weight;
  final String faDate;
  final String faTime;
  final List<CoinTradesDTO>? coins;

  const TradeDTO({
    required this.id,
    required this.buyAndSellType,
    required this.buyAndSellTypeString,
    required this.coinAndGoldType,
    required this.coinAndGoldTypeString,
    required this.statusString,
    required this.status,
    required this.mazaneh,
    required this.totalPrice,
    required this.weight,
    required this.faDate,
    required this.faTime,
    required this.coins,
  });

  factory TradeDTO.fromJson(Map<String, dynamic> json) => TradeDTO(
        id: json['id'],
        buyAndSellType: BuyAndSellType.fromCode(json['type']),
        buyAndSellTypeString: json['type_string'],
        // coinAndGoldType: CoinAndGoldType.fromCode(json['trade_type']),
        coinAndGoldType: CoinAndGoldType.gold,
        coinAndGoldTypeString: json['trade_type_string'] ?? '',
        status: json['status'],
        statusString: json['status_text'] ?? '',
        mazaneh: json['mazaneh'],
        totalPrice: json['total_price'],
        weight: json['weight'],
        faDate: json['FaDate'],
        faTime: json['FaTime'],
        coins: json['coins'] == null
            ? null
            : List<CoinTradesDTO>.from(json['coins'].map((e) => CoinTradesDTO.fromJson(e)).toList()),
      );

  @override
  List<Object?> get props => [
        id,
        buyAndSellType,
        buyAndSellTypeString,
        coinAndGoldType,
        coinAndGoldTypeString,
        statusString,
        status,
        mazaneh,
        totalPrice,
        weight,
        faDate,
        coins,
      ];
}
