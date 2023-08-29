import 'package:deniz_gold/data/dtos/coin_trade_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/data/dtos/paginated_result_dto.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';

part 'coint_trades_state.dart';

const perPage = 15;

@injectable
class CoinTradesCubit extends Cubit<CoinTradesState> {
  final AppRepository appRepository;

  CoinTradesCubit(this.appRepository) : super(const CoinTradesInitial(result: PaginatedResultDTO()));

  getData({int? tradeType, int? period, bool reset = false}) async {
    final result = state.result;
    if (!reset && state is! CoinTradesInitial && result.currentPage == result.lastPage) {
      return;
    }
    if (reset) {
      emit(const CoinTradesLoaded(result: PaginatedResultDTO()));
    }
    emit(CoinTradesLoading(result: state.result));
    final data = await appRepository.getCoinTrades(
      page: reset ? 1 : state.result.currentPage + 1,
      tradeType: tradeType,
      period: period,
    );
    data.fold(
      (l) => emit(CoinTradesFailed(result: state.result, message: l.message != null ? l.message! : "")),
      (r) => emit(CoinTradesLoaded(result: reset ? r : state.result.update(result: r))),
    );
  }
}
