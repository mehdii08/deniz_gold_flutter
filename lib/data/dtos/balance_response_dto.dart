import 'package:equatable/equatable.dart';

class BalanceResponseDTO extends Equatable {
  final bool balanceColorInfluens;
  final BalanceDTO rial;
  final BalanceDTO gold;

  const BalanceResponseDTO({
    required this.balanceColorInfluens,
    required this.rial,
    required this.gold,
  });

  factory BalanceResponseDTO.fromJson(Map<String, dynamic> json) => BalanceResponseDTO(
    balanceColorInfluens: json['balance_color_influens'],
    rial: BalanceDTO.fromJson(json['rial']),
    gold: BalanceDTO.fromJson(json['gold']),
  );

  @override
  List<Object?> get props => [
    rial,
    gold,
  ];
}

class BalanceDTO extends Equatable {
  final String balance;
  final String unit;

  const BalanceDTO({
    required this.balance,
    required this.unit,
  });

  factory BalanceDTO.fromJson(Map<String, dynamic> json) => BalanceDTO(
    balance: json['balance'],
    unit: json['unit'],
  );

  @override
  List<Object?> get props => [
    balance,
    unit,
  ];
}
