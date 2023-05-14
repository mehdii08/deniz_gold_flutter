import 'package:equatable/equatable.dart';

class BalanceDTO extends Equatable {
  final String rialBalance;
  final String goldBalance;

  const BalanceDTO({
    required this.rialBalance,
    required this.goldBalance,
  });

  factory BalanceDTO.fromJson(Map<String, dynamic> json) => BalanceDTO(
        rialBalance: json['rial_balance'].toString(),
        goldBalance: json['gold_balance'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'rial_balance': rialBalance,
        'gold_balance': goldBalance,
      };

  @override
  List<Object?> get props => [
        rialBalance,
        goldBalance,
      ];
}
