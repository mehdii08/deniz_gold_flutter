import 'package:deniz_gold/data/dtos/trade_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';

part 'check_trade_status_state.dart';

@injectable
class CheckTradeStatusCubit extends Cubit<CheckTradeStatusState> {
  final AppRepository appRepository;

  CheckTradeStatusCubit({
    required this.appRepository,
  }) : super(const CheckTradeStatusInitial());

  check({required int tradeId}) async {
    emit(const CheckTradeStatusLoading());
    final result = await appRepository.checkTradeStatus(tradeId: tradeId);
    result.fold(
      (l) => emit(CheckTradeStatusFailed(message: l.message != null ? l.message! : "")),
      (r) => emit(CheckTradeStatusLoaded(trade: r)),
    );
  }
}
