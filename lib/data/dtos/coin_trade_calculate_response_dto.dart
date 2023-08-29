import 'package:equatable/equatable.dart';

class CoinTradeCalculateResponseDTO extends Equatable {
  final List<CalculateResponseCoinDTO> coins;
  final String pricesSum;

  const CoinTradeCalculateResponseDTO({
    required this.coins,
    required this.pricesSum,
  });

  factory CoinTradeCalculateResponseDTO.fromJson(Map<String, dynamic> json) {
    return CoinTradeCalculateResponseDTO(
        coins: List<CalculateResponseCoinDTO>.from(
            json['coins'].map((e) => CalculateResponseCoinDTO.fromJson(e)).toList()),
        pricesSum: json['prices_sum'],
      );
  }

  @override
  List<Object?> get props => [
        coins,
        pricesSum,
      ];
}

class CalculateResponseCoinDTO extends Equatable {
  final String title;
  final String count;

  const CalculateResponseCoinDTO({
    required this.title,
    required this.count,
  });

  factory CalculateResponseCoinDTO.fromJson(Map<String, dynamic> json) => CalculateResponseCoinDTO(
        title: json['title'],
        count: json['count'],
      );

  @override
  List<Object?> get props => [
        title,
        count,
      ];
}
