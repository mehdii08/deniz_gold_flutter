import 'package:equatable/equatable.dart';

class CoinDTO extends Equatable {
  final int id;
  final String title;
  final String buyPrice;
  final String sellPrice;
  final String change;

  const CoinDTO({
    required this.id,
    required this.title,
    required this.buyPrice,
    required this.sellPrice,
    required this.change,
  });

  factory CoinDTO.fromJson(Map<String, dynamic> json) => CoinDTO(
        id: json['id'],
        title: json['title'],
        buyPrice: json['buy_price'],
        sellPrice: json['sell_price'],
        change: json['change'] ?? '',
      );


  @override
  List<Object?> get props => [
        id,
        title,
        buyPrice,
        sellPrice,
        change,
      ];
}
