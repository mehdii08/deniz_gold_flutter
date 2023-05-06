import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';

part 'forget_password_state.dart';

@injectable
class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final AppRepository appRepository;

  ForgetPasswordCubit(this.appRepository) : super(const ForgetPasswordInitial());

  sendOTPCode(String mobile) async {
    emit(ForgetPasswordLoading(mobile));
    final result = await appRepository.sendOTPCode(mobile: mobile);
    result.fold(
      (l) => emit(ForgetPasswordFailed(mobile: mobile, message: l.message != null ? l.message! : "")),
      (r) => emit(ForgetPasswordLoaded(mobile: mobile)),
    );
  }
}
