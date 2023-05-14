import 'package:deniz_gold/data/dtos/transaction_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';

part 'transactions_state.dart';

@injectable
class TransactionsCubit extends Cubit<TransactionsState> {
  final AppRepository appRepository;

  TransactionsCubit(this.appRepository) : super(const TransactionsInitial(transactions: []));

  getData({String count = "40"}) async {
    emit(TransactionsLoading(transactions: state.transactions));
    final result = await appRepository.getTransactions(count : count);
    result.fold(
      (l) => emit(TransactionsFailed(transactions: state.transactions, message: l.message != null ? l.message! : "")),
      (r) => emit(TransactionsLoaded(transactions: r)),
    );
  }
}
