import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/data/dtos/balance_response_dto.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';

part 'balance_state.dart';

@injectable
class BalanceCubit extends Cubit<BalanceState> {
  final AppRepository appRepository;

  BalanceCubit({
    required this.appRepository,
  }) : super(const BalanceInitial());

  getData() async {
    emit(const BalanceLoading());
    final result = await appRepository.getBalance();
    result.fold(
      (l) => emit(BalanceFailed(message: l.message != null ? l.message! : "")),
      (r) => emit(BalanceLoaded(data: r)),
    );
  }

  reset() async {
    emit(const BalanceInitial());
  }
}
