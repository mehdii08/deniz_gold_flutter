import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../data/dtos/coint_trades_detail_dto.dart';

part 'coint_trades_detail_state.dart';

@injectable
class CoinTradesDetailCubit extends Cubit<CoinTradesDetailState> {
  final AppRepository appRepository;

  CoinTradesDetailCubit(this.appRepository) : super(const CoinTradesDetailInitial(result: CoinTradeDetailDTO.fake()));

  getData({ required int id}) async {

    emit(CoinTradesDetailLoading(result: state.result));
    final data = await appRepository.getCoinTradesDetail(
      id: id
    );
    data.fold(
      (l) => emit(CoinTradesDetailFailed(result: state.result, message: l.message != null ? l.message! : "")),
      (r) => emit(CoinTradesDetailLoaded(result: r )),
    );
  }
}
