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
  final bool isResend;
  const VerifyMobileLoading({this.isResend = false}) : super();

  @override
  List<Object?> get props => [isResend];
}

class CheckMobileLoaded extends VerifyMobileState {
  final String mobile;
  final bool exists;
  final int smsOtpCodeExpirationTime;
  const CheckMobileLoaded({required this.mobile, required this.exists, required this.smsOtpCodeExpirationTime});

  @override
  List<Object?> get props => [mobile, exists, smsOtpCodeExpirationTime];
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
