part of 'coint_trades_detail_cubit.dart';

abstract class CoinTradesDetailState extends Equatable {
  final CoinTradeDetailDTO result;
  const CoinTradesDetailState({required this.result});

  @override
  List<Object?> get props => [result];
}

class CoinTradesDetailInitial extends CoinTradesDetailState {
  const CoinTradesDetailInitial({required CoinTradeDetailDTO result}) : super(result: result);
}

class CoinTradesDetailLoading extends CoinTradesDetailState {
  const CoinTradesDetailLoading({required CoinTradeDetailDTO result}) : super(result: result);
}

class CoinTradesDetailLoaded extends CoinTradesDetailState {
  const CoinTradesDetailLoaded({required CoinTradeDetailDTO result}) : super(result: result);
}

class CoinTradesDetailFailed extends CoinTradesDetailState {
  final String message;

  const CoinTradesDetailFailed({
  required CoinTradeDetailDTO result,
    required this.message,
  }) : super(result: result);

  @override
  List<Object?> get props => [result, message];
}
