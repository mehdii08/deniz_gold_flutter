import 'package:equatable/equatable.dart';

import 'coin_trades_dto.dart';

class CoinTradeDetailDTO extends Equatable {
  final String type;
  final String total_price;
  final List<CoinTradesDTO>? coins;


  const CoinTradeDetailDTO({
    required this.type,
    required this.total_price,
    required this.coins,
  });

  const CoinTradeDetailDTO.fake({
     this.type="",
     this.total_price="",
     this.coins=const [],
  });


  factory CoinTradeDetailDTO.fromJson(Map<String, dynamic> json) => CoinTradeDetailDTO(
    type: json['type'],
    total_price: json['total_price'],
    coins: List<CoinTradesDTO>.from(json['coins'].map((e) => CoinTradesDTO.fromJson(e)).toList()),
      );

  @override
  List<Object?> get props => [type, total_price, coins];
}
