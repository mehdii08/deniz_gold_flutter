import 'package:deniz_gold/data/dtos/transaction_dto.dart';
import 'package:equatable/equatable.dart';

class TransactionsResultDTO extends Equatable {
  final List<TransactionDTO> transactions;
  final bool hasMorePage;

  const TransactionsResultDTO({
    required this.transactions,
    required this.hasMorePage,
  });

  factory TransactionsResultDTO.fromJson(Map<String, dynamic> json)=> TransactionsResultDTO(
      transactions: List<TransactionDTO>.from(json['list']
          .map((e) => TransactionDTO.fromJson(e))
          .toList()),
      hasMorePage: json['has_more_page'],
    );

  @override
  List<Object?> get props => [
        transactions,
        hasMorePage,
      ];
}
