import 'package:deniz_gold/data/dtos/balance_response_dto.dart';
import 'package:equatable/equatable.dart';

class TransactionDTO extends Equatable {
  final String type;
  final String title;
  final String description;
  final String date;
  final String time;
  final BalanceResponseDTO? balance;


  const TransactionDTO({
    required this.type,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.balance,

  });

  factory TransactionDTO.fromJson(Map<String, dynamic> json) => TransactionDTO(
        type: json['type'],
        title: json['title'],
        description: json['description'],
        date: json['date'],
        time: json['time'],
    balance: json['balance'] == null ? null : BalanceResponseDTO.fromJson(json['balance']),

  );

  @override
  List<Object?> get props => [type, title, description, date, time,balance];
}
