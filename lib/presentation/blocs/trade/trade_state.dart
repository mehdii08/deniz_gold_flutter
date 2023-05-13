part of 'trade_cubit.dart';

abstract class TradeState extends Equatable {
  const TradeState();

  @override
  List<Object?> get props => [];
}

class TradeInitial extends TradeState {
  const TradeInitial() : super();
}

class TradeLoading extends TradeState {
  final bool calculateLoading;
  final bool submitLoading;
  const TradeLoading({required this.calculateLoading, required this.submitLoading}) : super();

  @override
  List<Object?> get props => [];
}

class TradeCalculateLoaded extends TradeState {
  final TradeCalculateResponseDTO data;
  const TradeCalculateLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class TradeSubmited extends TradeState {
  final TradeSubmitResponseDTO data;
  final String message;
  const TradeSubmited({required this.message, required this.data});

  @override
  List<Object?> get props => [message, data];
}

class TradeAnswerReached extends TradeState {
  final String status;
  final String totalPrice;
  final String mazaneh;
  final String weight;
  const TradeAnswerReached({
    required this.status,
    required this.totalPrice,
    required this.mazaneh,
    required this.weight,
  }) : super();
}

class TradeFailed extends TradeState {
  final String message;

  const TradeFailed({
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [message];
}
