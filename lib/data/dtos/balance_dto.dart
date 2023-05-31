import 'package:equatable/equatable.dart';

class BalanceDTO extends Equatable {
  final int balance;
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
