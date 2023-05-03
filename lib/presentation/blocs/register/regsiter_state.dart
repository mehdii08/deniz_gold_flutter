part of 'register_cubit.dart';

abstract class RegisterState extends Equatable {

  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial() : super();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading() : super();
}

class RegisterLoaded extends RegisterState {
  final String token;
  const RegisterLoaded({required this.token});

  @override
  List<Object?> get props => [token];
}

class RegisterFailed extends RegisterState {
  final String message;

  const RegisterFailed({
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [message];
}
