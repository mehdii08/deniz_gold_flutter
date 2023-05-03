import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:deniz_gold/domain/repositories/shared_preferences_repository.dart';
import 'package:deniz_gold/presentation/blocs/auth/authentication_cubit.dart';
import 'package:injectable/injectable.dart';

part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final AppRepository appRepository;
  final SharedPreferencesRepository sharedPreferences;

  LoginCubit({
    required this.appRepository,
    required this.sharedPreferences,
  }) : super(const LoginInitial());

  login({
    required String mobile,
    required String password,
  }) async {
    emit(const LoginLoading());
    final result = await appRepository.login(mobile: mobile, password: password);
    result.fold(
      (l) => emit(LoginFailed(message: l.message != null ? l.message! : "")),
      (r) {
        sharedPreferences.setString(authTokenKey, r);
        emit(const LoginSuccess());
      },
    );
  }
}
