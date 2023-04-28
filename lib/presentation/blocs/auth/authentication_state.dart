part of 'authentication_cubit.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  final String? token;

  const AuthenticationState(this.token);

  @override
  List<Object?> get props => [token];
}

class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial() : super(null);
}

class AuthenticationLoading extends AuthenticationState {
  const AuthenticationLoading() : super(null);
}

class Authenticated extends AuthenticationState {
  const Authenticated(super.token);
}

class UnAuthenticated extends AuthenticationState {
  final DateTime? dateTime;
  const UnAuthenticated({this.dateTime, String? token}) : super(token);

  @override
  List<Object?> get props => [dateTime, token];
}
