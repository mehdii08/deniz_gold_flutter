part of 'forget_password_cubit.dart';

abstract class ForgetPasswordState extends Equatable {

  const ForgetPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgetPasswordInitial extends ForgetPasswordState {
  const ForgetPasswordInitial() : super();
}

class ForgetPasswordLoading extends ForgetPasswordState {
  final String mobile;
  const ForgetPasswordLoading(this.mobile) : super();

  @override
  List<Object?> get props => [mobile];
}

class ForgetPasswordLoaded extends ForgetPasswordState {
  final String mobile;
  const ForgetPasswordLoaded({required this.mobile});

  @override
  List<Object?> get props => [mobile];
}

class ForgetPasswordFailed extends ForgetPasswordState {
  final String mobile;
  final String message;

  const ForgetPasswordFailed({
    required this.mobile,
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [mobile, message];
}
