part of 'coint_trades_cubit.dart';

abstract class CoinTradesState extends Equatable {
  final PaginatedResultDTO<CoinTradeDTO> result;
  const CoinTradesState({required this.result});

  @override
  List<Object?> get props => [result];
}

class CoinTradesInitial extends CoinTradesState {
  const CoinTradesInitial({required PaginatedResultDTO<CoinTradeDTO> result}) : super(result: result);
}

class CoinTradesLoading extends CoinTradesState {
  const CoinTradesLoading({required PaginatedResultDTO<CoinTradeDTO> result}) : super(result: result);
}

class CoinTradesLoaded extends CoinTradesState {
  const CoinTradesLoaded({required PaginatedResultDTO<CoinTradeDTO> result}) : super(result: result);
}

class CoinTradesFailed extends CoinTradesState {
  final String message;

  const CoinTradesFailed({
  required PaginatedResultDTO<CoinTradeDTO> result,
    required this.message,
  }) : super(result: result);

  @override
  List<Object?> get props => [result, message];
}
