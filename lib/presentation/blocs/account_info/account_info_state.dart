part of 'account_info_cubit.dart';

abstract class AccountInfoState extends Equatable {
  const AccountInfoState();

  @override
  List<Object?> get props => [];
}

class AccountInfoInitial extends AccountInfoState {
  const AccountInfoInitial() : super();
}

class AccountInfoLoading extends AccountInfoState {
  const AccountInfoLoading() : super();
}

class AccountInfoLoaded extends AccountInfoState {
  final String message;

  const AccountInfoLoaded({
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [message];
}

class AccountInfoFailed extends AccountInfoState {
  final String message;

  const AccountInfoFailed({
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [message];
}
