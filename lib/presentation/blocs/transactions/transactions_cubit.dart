import 'package:deniz_gold/data/dtos/transaction_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

part 'transactions_state.dart';

@injectable
class TransactionsCubit extends Cubit<TransactionsState> {
  final AppRepository appRepository;
  int _page = 1;

  TransactionsCubit(this.appRepository)
      : super(const TransactionsInitial(transactions: []));

  getData() async {
    if (!state.hasMorePage || state is TransactionsLoading) {
      return;
    }
    emit(TransactionsLoading(transactions: state.transactions));
    final result = await appRepository.getTransactions(page: _page);
    result.fold(
          (l) =>
          emit(TransactionsFailed(transactions: state.transactions,
              message: l.message != null ? l.message! : "")),
          (r) {
        _page++;
        emit(TransactionsLoaded(
            transactions: [...state.transactions, ...r.transactions],
            hasMorePage: r.hasMorePage));
      },
    );
  }

  getPdf() async {
    emit(TransactionsLoading(transactions: state.transactions));
    final result = await appRepository.getPdf();
    result.fold(
          (l) =>
          emit(TransactionsFailed(transactions: state.transactions,
              message: l.message != null ? l.message! : "")),
          (r) {
        emit(TransactionsLoaded(
            transactions: state.transactions, hasMorePage: state.hasMorePage));
        _launchURL(r);
      },
    );
  }

  _launchURL(String urlAddress) async {
    final Uri url = Uri.parse(urlAddress);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
