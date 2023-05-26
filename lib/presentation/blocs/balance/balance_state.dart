part of 'balance_cubit.dart';

abstract class BalanceState extends Equatable {

  const BalanceState();

  @override
  List<Object?> get props => [];
}

class BalanceInitial extends BalanceState {
  const BalanceInitial() : super();
}

class BalanceLoading extends BalanceState {
  const BalanceLoading() : super();

  @override
  List<Object?> get props => [];
}

class BalanceLoaded extends BalanceState {
  final BalanceDTO data;
  const BalanceLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class BalanceFailed extends BalanceState {
  final String message;

  const BalanceFailed({
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [message];
}
