import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';

part 'reset_password_state.dart';

@injectable
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AppRepository appRepository;

  ResetPasswordCubit(this.appRepository) : super(const ResetPasswordInitial());

  resetPassword({
    required String code,
    required String mobile,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(const ResetPasswordLoading());
    final result = await appRepository.resetPassword(
        code: code,
        mobile: mobile,
        password: password,
        passwordConfirmation: passwordConfirmation);
    result.fold(
      (l) => emit(ResetPasswordFailed(message: l.message != null ? l.message! : "")),
      (r) {
        emit(ResetPasswordLoaded(message: r));
      }
    );
  }
}
