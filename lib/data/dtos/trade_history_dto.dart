import 'package:deniz_gold/data/enums.dart';
import 'package:equatable/equatable.dart';

class TradeHistoryDTO extends Equatable {
  final int id;
  final BuyAndSellType type;
  final String typeString;
  final int mazaneh;
  final int status;
  final String statusText;
  final int totalPrice;
  final String value;
  final String valueUnit;
  final String faDate;
  final String faTime;

  const TradeHistoryDTO({
    required this.id,
    required this.type,
    required this.typeString,
    required this.status,
    required this.mazaneh,
    required this.totalPrice,
    required this.value,
    required this.statusText,
    required this.valueUnit,
    required this.faDate,
    required this.faTime,
  });

  factory TradeHistoryDTO.fromJson(Map<String, dynamic> json) => TradeHistoryDTO(
    id: json['id'],
    statusText: json['status_text'] ?? '',
    valueUnit: json['value_unit'] ?? '',
    type: BuyAndSellType.fromCode(json['type']),
    typeString: json['type_string'],
    status: json['status'],
    mazaneh: json['mazaneh'],
    totalPrice: json['total_price'],
    value: json['value'],
    faDate: json['FaDate'],
    faTime: json['FaTime'],
  );

  @override
  List<Object?> get props => [
    id,
    type,
    typeString,
    status,
    mazaneh,
    totalPrice,
    value,
    faDate,
    faTime,
    valueUnit,
    statusText,
  ];
}
