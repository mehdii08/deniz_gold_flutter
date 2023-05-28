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

  const ProfileSuccess({required this.appConfig}) : super();

  @override
  List<Object?> get props => [appConfig];

}

class ProfileFailed extends ProfileState {
  final String message;

  const ProfileFailed({
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [message];
}
