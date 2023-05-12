import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:deniz_gold/domain/repositories/shared_preferences_repository.dart';
import 'package:injectable/injectable.dart';

part 'verify_mobile_state.dart';

@injectable
class VerifyMobileCubit extends Cubit<VerifyMobileState> {
  final AppRepository appRepository;
  final SharedPreferencesRepository sharedPreferences;

  VerifyMobileCubit({
    required this.appRepository,
    required this.sharedPreferences,
  }) : super(const VerifyMobileInitial());

  verify({
    required String mobile,
    required String code,
    required bool isRegister,
  }) async {
    emit(const VerifyMobileLoading());
    final result = await appRepository.verifyMobile(mobile: mobile, code: code, isRegister: isRegister);
    result.fold(
      (l) => emit(VerifyMobileFailed(message: l.message != null ? l.message! : "")),
      (r) {
        emit(VerifyMobileSuccess(token: r));
      },
    );
  }
}
