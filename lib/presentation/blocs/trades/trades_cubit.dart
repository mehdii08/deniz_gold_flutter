import 'package:deniz_gold/data/dtos/trade_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/data/dtos/paginated_result_dto.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';

part 'trades_state.dart';

const perPage = 15;
@injectable
class TradesCubit extends Cubit<TradesState> {
  final AppRepository appRepository;

  TradesCubit(this.appRepository) : super(const TradesInitial(result: PaginatedResultDTO()));

  getData() async {
    final result = state.result;
    if(state is! TradesInitial && result.currentPage == result.lastPage){
      return;
    }
    emit(TradesLoading(result: state.result));
    final data = await appRepository.getTrades(page: state.result.currentPage + 1);
    data.fold(
      (l) => emit(TradesFailed(result: state.result, message: l.message != null ? l.message! : "")),
      (r) => emit(TradesLoaded(result: state.result.update(result: r))),
    );
  }
}
