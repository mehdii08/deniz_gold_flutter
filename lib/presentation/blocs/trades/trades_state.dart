part of 'trades_cubit.dart';

abstract class TradesState extends Equatable {
  final PaginatedResultDTO<TradeHistoryDTO> result;
  const TradesState({required this.result});

  @override
  List<Object?> get props => [result];
}

class TradesInitial extends TradesState {
  const TradesInitial({required PaginatedResultDTO<TradeHistoryDTO> result}) : super(result: result);
}

class TradesLoading extends TradesState {
  const TradesLoading({required PaginatedResultDTO<TradeHistoryDTO> result}) : super(result: result);
}

class TradesLoaded extends TradesState {
  const TradesLoaded({required PaginatedResultDTO<TradeHistoryDTO> result}) : super(result: result);
}

class TradesFailed extends TradesState {
  final String message;

  const TradesFailed({
  required PaginatedResultDTO<TradeHistoryDTO> result,
    required this.message,
  }) : super(result: result);

  @override
  List<Object?> get props => [result, message];
}
