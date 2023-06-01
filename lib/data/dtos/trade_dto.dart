import 'package:deniz_gold/data/enums.dart';
import 'package:equatable/equatable.dart';

class TradeDTO extends Equatable {
  final int id;
  final TradeType type;
  final String typeString;
  final int mazaneh;
  final int totalPrice;
  final String weight;
  final String faDate;
  final String faTime;

  const TradeDTO({
    required this.id,
    required this.type,
    required this.typeString,
    required this.mazaneh,
    required this.totalPrice,
    required this.weight,
    required this.faDate,
    required this.faTime,
  });

  factory TradeDTO.fromJson(Map<String, dynamic> json) => TradeDTO(
        id: json['id'],
        type: TradeType.fromCode(json['type']),
        typeString: json['type_string'],
        mazaneh: json['mazaneh'],
        totalPrice: json['total_price'],
        weight: json['weight'],
        faDate: json['FaDate'],
        faTime: json['FaTime'],
      );

  @override
  List<Object?> get props => [
        id,
        type,
        typeString,
        mazaneh,
        totalPrice,
        weight,
        faDate,
        faTime,
      ];
}
