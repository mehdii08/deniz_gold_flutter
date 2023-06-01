part of 'check_mobile_cubit.dart';

abstract class CheckMobileState extends Equatable {
  const CheckMobileState();

  @override
  List<Object?> get props => [];
}

class CheckMobileInitial extends CheckMobileState {
  const CheckMobileInitial() : super();
}

class CheckMobileLoading extends CheckMobileState {
  final String mobile;
  const CheckMobileLoading(this.mobile) : super();

  @override
  List<Object?> get props => [mobile];
}

class CheckMobileLoaded extends CheckMobileState {
  final String mobile;
  final bool exists;
  final int smsOtpCodeExpirationTime;
  const CheckMobileLoaded({required this.mobile, required this.exists, required this.smsOtpCodeExpirationTime});

  @override
  List<Object?> get props => [mobile, exists, smsOtpCodeExpirationTime];
}

class CheckMobileFailed extends CheckMobileState {
  final String mobile;
  final String message;

  const CheckMobileFailed({
    required this.mobile,
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [mobile, message];
}
