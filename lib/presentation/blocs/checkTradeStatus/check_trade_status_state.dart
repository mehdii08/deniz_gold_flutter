part of 'check_trade_status_cubit.dart';

abstract class CheckTradeStatusState extends Equatable {

  const CheckTradeStatusState();

  @override
  List<Object?> get props => [];
}

class CheckTradeStatusInitial extends CheckTradeStatusState {
  const CheckTradeStatusInitial() : super();
}

class CheckTradeStatusLoading extends CheckTradeStatusState {
  const CheckTradeStatusLoading() : super();

  @override
  List<Object?> get props => [];
}

class CheckTradeStatusLoaded extends CheckTradeStatusState {
  final TradeResultNotificationEvent data;
  const CheckTradeStatusLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class CheckTradeStatusFailed extends CheckTradeStatusState {
  final String message;

  const CheckTradeStatusFailed({
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [message];
}
