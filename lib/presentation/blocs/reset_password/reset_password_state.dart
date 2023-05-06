part of 'reset_password_cubit.dart';

abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object?> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {
  const ResetPasswordInitial() : super();
}

class ResetPasswordLoading extends ResetPasswordState {
  const ResetPasswordLoading() : super();
}

class ResetPasswordLoaded extends ResetPasswordState {
  final String message;
  const ResetPasswordLoaded({required this.message});

  @override
  List<Object?> get props => [message];
}

class ResetPasswordFailed extends ResetPasswordState {
  final String message;

  const ResetPasswordFailed({
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [message];
}
