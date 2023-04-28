import 'package:equatable/equatable.dart';

class PriceDTO extends Equatable {
  final String buyPrice;
  final String sellPrice;
  final String time;

  const PriceDTO({
    required this.buyPrice,
    required this.sellPrice,
    required this.time,
  });

  factory PriceDTO.fromJson(Map<String, dynamic> json) => PriceDTO(
        buyPrice: json['buy_price'],
        sellPrice: json['sell_price'],
        time: json['time'],
      );

  @override
  List<Object?> get props => [buyPrice, sellPrice, time];
}
