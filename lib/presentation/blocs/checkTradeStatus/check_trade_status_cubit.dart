import 'package:deniz_gold/data/dtos/trade_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../core/utils/app_notification_handler.dart';

part 'check_trade_status_state.dart';

@injectable
class CheckTradeStatusCubit extends Cubit<CheckTradeStatusState> {
  final AppRepository appRepository;

  CheckTradeStatusCubit({
    required this.appRepository,
  }) : super(const CheckTradeStatusInitial());

  check({required int tradeId, bool silent = false}) async {
    if (!silent) {
      emit(const CheckTradeStatusLoading());
    }
    final result = await appRepository.checkTradeStatus(tradeId: tradeId, needCancel: silent ? 0 : 1);
    result.fold(
      (l) => {
        if (!silent) {emit(CheckTradeStatusFailed(message: l.message != null ? l.message! : ""))}
      },
      (r) => {
        if(r.status != 0 || !silent){
          emit(CheckTradeStatusLoaded(data: r))
        }
      },
    );
  }
}
