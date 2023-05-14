part of 'transactions_cubit.dart';

abstract class TransactionsState extends Equatable {
  final List<TransactionDTO> transactions;
  const TransactionsState({required this.transactions});

  @override
  List<Object?> get props => [transactions];
}

class TransactionsInitial extends TransactionsState {
  const TransactionsInitial({required List<TransactionDTO> transactions}) : super(transactions: transactions);
}

class TransactionsLoading extends TransactionsState {
  const TransactionsLoading({required List<TransactionDTO> transactions}) : super(transactions: transactions);
}

class TransactionsLoaded extends TransactionsState {
  const TransactionsLoaded({required List<TransactionDTO> transactions}) : super(transactions: transactions);

  @override
  List<Object?> get props => [transactions];
}

class TransactionsFailed extends TransactionsState {
  final String message;

  const TransactionsFailed({
  required List<TransactionDTO> transactions,
    required this.message,
  }) : super(transactions: transactions);

  @override
  List<Object?> get props => [transactions, message];
}
