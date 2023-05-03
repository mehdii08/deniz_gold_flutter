part of 'verify_mobile_cubit.dart';

abstract class VerifyMobileState extends Equatable {

  const VerifyMobileState();

  @override
  List<Object?> get props => [];
}

class VerifyMobileInitial extends VerifyMobileState {
  const VerifyMobileInitial() : super();
}

class VerifyMobileLoading extends VerifyMobileState {
  const VerifyMobileLoading() : super();
}

class VerifyMobileSuccess extends VerifyMobileState {
  final String token;
  const VerifyMobileSuccess({required this.token}): super();
}

class VerifyMobileFailed extends VerifyMobileState {
  final String message;

  const VerifyMobileFailed({
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [message];
}
