part of 'splash_cubit.dart';

abstract class SplashState extends Equatable {

  const SplashState();

  @override
  List<Object?> get props => [DateTime.now().millisecondsSinceEpoch];
}

class SplashInitial extends SplashState {
  const SplashInitial() : super();
}

class SplashLoading extends SplashState {
  const SplashLoading() : super();
}

class SplashAuthenticationChecked extends SplashState {
  final bool authenticated;
  const SplashAuthenticationChecked({required this.authenticated});

  @override
  List<Object?> get props => [authenticated];
}

class SplashLoaded extends SplashState {
  const SplashLoaded();
}

class SplashUpdateNeeded extends SplashState {
  final AppVersionDTO appVersion;
  const SplashUpdateNeeded({required this.appVersion});
}

class SplashFailed extends SplashState {
  final String message;

  const SplashFailed({
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [message];
}

