import 'package:deniz_gold/data/enums.dart';
import 'package:equatable/equatable.dart';

class CoinTradeDTO extends Equatable {
  final int id;
  final String typeString;
  final BuyAndSellType type;
  final String statusString;
  final int totalPrice;
  final String count;
  final int status;
  final String faDate;

  const CoinTradeDTO({
    required this.id,
    required this.typeString,
    required this.type,
    required this.status,
    required this.statusString,
    required this.totalPrice,
    required this.count,
    required this.faDate,
  });

  factory CoinTradeDTO.fromJson(Map<String, dynamic> json) => CoinTradeDTO(
        id: json['id'],
        typeString: json['type_string'],
        type: BuyAndSellType.fromCode(json['type']),
        statusString: json['status_text'],
        status: json['status'],
        totalPrice: int.parse(json['total_price']),
        count: json['count'],
        faDate: json['date'],
      );

  @override
  List<Object?> get props => [
        id,
        typeString,
        statusString,
        totalPrice,
        status,
        count,
        faDate,
      ];
}
