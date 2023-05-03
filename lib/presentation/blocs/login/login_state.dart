part of 'login_cubit.dart';


abstract class LoginState extends Equatable {

  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial() : super();
}

class LoginLoading extends LoginState {
  const LoginLoading() : super();
}

class LoginSuccess extends LoginState {
  const LoginSuccess(): super();
}

class LoginFailed extends LoginState {
  final String message;

  const LoginFailed({
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [message];
}
