import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/data/dtos/app_config_dto.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:deniz_gold/domain/repositories/shared_preferences_repository.dart';
import 'package:deniz_gold/presentation/blocs/splash/splash_cubit.dart';
import 'package:injectable/injectable.dart';

part 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final AppRepository appRepository;
  final SharedPreferencesRepository sharedPreferences;
  String _goldBalance = "";
  String _rialBalance = "";

  ProfileCubit({
    required this.appRepository,
    required this.sharedPreferences,
  }) : super(const ProfileInitial()){
    getBalance();
  }

  getBalance() async {
    final result = await appRepository.getBalance();
    result.fold(
      (l) {},
      (r) async {
        _goldBalance = r.goldBalance;
        _rialBalance = r.rialBalance;
        if (state is ProfileSuccess) {//todo its not emitted
          emit((state as ProfileSuccess).copy(goldBalance: _goldBalance, rialBalance: _rialBalance));
        }
      },
    );
  }

  updateData() {
    final String appConfigString = sharedPreferences.getString(appConfigKey);
    if (appConfigString.isNotEmpty) {
      emit(ProfileSuccess(
        appConfig: AppConfigDTO.fromJson(jsonDecode(appConfigString)),
        rialBalance: _rialBalance,
        goldBalance: _goldBalance,
      ));
    }
  }
}
