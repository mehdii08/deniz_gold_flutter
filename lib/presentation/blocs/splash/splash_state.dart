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
  final bool showUpdateDetails;
  final List<String> description;
  const SplashLoaded({required this.showUpdateDetails,required this.description});
}

class SplashUpdateNeeded extends SplashState {
  final bool forceUpdate;
  final AppVersionDTO appVersion;

  const SplashUpdateNeeded({required this.appVersion,required this.forceUpdate});
}

class SplashFailed extends SplashState {
  final String message;

  const SplashFailed({
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [message];
}

