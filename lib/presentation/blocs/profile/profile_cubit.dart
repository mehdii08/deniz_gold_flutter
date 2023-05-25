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

  ProfileCubit({
    required this.appRepository,
    required this.sharedPreferences,
  }) : super(const ProfileInitial());

  updateData() {
    final String appConfigString = sharedPreferences.getString(appConfigKey);
    if (appConfigString.isNotEmpty) {
      emit(ProfileSuccess(appConfig: AppConfigDTO.fromJson(jsonDecode(appConfigString))));
    }
  }
}
