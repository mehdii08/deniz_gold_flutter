import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';

part 'regsiter_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  final AppRepository appRepository;

  RegisterCubit(this.appRepository) : super(const RegisterInitial());

  register({
    required String token,
    required String mobile,
    required String name,
    required String nationalCode,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(const RegisterLoading());
    final result = await appRepository.register(
        token: token,
        mobile: mobile,
        name: name,
        nationalCode: nationalCode,
        password: password,
        passwordConfirmation: passwordConfirmation);
    result.fold(
      (l) => emit(RegisterFailed(message: l.message != null ? l.message! : "")),
      (r) {
        emit(RegisterLoaded(token: r));
      }
    );
  }
}
