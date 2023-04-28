import 'package:equatable/equatable.dart';

class TradeCalculateResponseDTO extends Equatable {
  final String totalPrice;
  final String mazaneh;
  final String weight;

  const TradeCalculateResponseDTO({
    required this.totalPrice,
    required this.mazaneh,
    required this.weight,
  });

  factory TradeCalculateResponseDTO.fromJson(Map<String, dynamic> json) => TradeCalculateResponseDTO(
        totalPrice: json['total_price'],
        mazaneh: json['mazaneh'],
        weight: json['weight'],
      );

  @override
  List<Object?> get props => [totalPrice, mazaneh, weight,];
}
