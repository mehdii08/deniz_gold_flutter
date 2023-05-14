part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial() : super();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading() : super();
}

class ProfileSuccess extends ProfileState {
  final AppConfigDTO appConfig;
  final String goldBalance;
  final String rialBalance;

  const ProfileSuccess({
    required this.appConfig,
    required this.goldBalance,
    required this.rialBalance,
  }) : super();

  copy({required String goldBalance, required String rialBalance}) => ProfileSuccess(
        appConfig: appConfig,
        goldBalance: goldBalance,
        rialBalance: rialBalance,
      );
}

class ProfileFailed extends ProfileState {
  final String message;

  const ProfileFailed({
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [message];
}
