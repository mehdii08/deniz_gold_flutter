part of 'support_cubit.dart';

abstract class SupportState extends Equatable {

  const SupportState();

  @override
  List<Object?> get props => [];
}

class SupportInitial extends SupportState {
  const SupportInitial() : super();
}

class SupportLoading extends SupportState {
  const SupportLoading() : super();

  @override
  List<Object?> get props => [];
}

class SupportLoaded extends SupportState {
  final List<PhoneDTO>? phones;
  const SupportLoaded({required this.phones});

  @override
  List<Object?> get props => [phones];
}

class SupportFailed extends SupportState {
  final String message;

  const SupportFailed({
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [message];
}
