import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';

part 'account_info_state.dart';

@injectable
class AccountInfoCubit extends Cubit<AccountInfoState> {
  final AppRepository appRepository;

  AccountInfoCubit(this.appRepository) : super(const AccountInfoInitial());

  updateName({required String name}) async {
    emit(const AccountInfoLoading());
    final data = await appRepository.updateName(name: name);
    data.fold(
          (l) => emit(AccountInfoFailed(message: l.message != null ? l.message! : "")),
          (r) => emit(AccountInfoLoaded(message: r)),
    );
  }

  updatePassword({required String currentPassword, required String newPassword}) async {
    emit(const AccountInfoLoading());
    final data = await appRepository.changePassword(password: newPassword, passwordConfirmation: newPassword);
    data.fold(
          (l) => emit(AccountInfoFailed(message: l.message != null ? l.message! : "")),
          (r) => emit(AccountInfoLoaded(message: r)),
    );
  }
}
