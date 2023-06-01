import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';

part 'check_mobile_state.dart';

@injectable
class CheckMobileCubit extends Cubit<CheckMobileState> {
  final AppRepository appRepository;

  CheckMobileCubit(this.appRepository) : super(const CheckMobileInitial());

  checkMobileExists(String mobile) async {
    emit(CheckMobileLoading(mobile));
    final result = await appRepository.checkMobileExists(mobile: mobile);
    result.fold(
      (l) => emit(CheckMobileFailed(
          mobile: mobile, message: l.message != null ? l.message! : "")),
      (r) => emit(CheckMobileLoaded(mobile: mobile, exists: r.exists, smsOtpCodeExpirationTime: r.smsOtpCodeExpirationTime ?? 190)),
    );
  }
}
