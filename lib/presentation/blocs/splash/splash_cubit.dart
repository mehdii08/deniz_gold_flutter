import 'dart:convert';

import 'package:deniz_gold/data/dtos/app_version_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:deniz_gold/domain/repositories/shared_preferences_repository.dart';
import 'package:deniz_gold/presentation/blocs/auth/authentication_cubit.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'splash_state.dart';

const appConfigKey = 'app_config';

@injectable
class SplashCubit extends Cubit<SplashState> {
  final AppRepository appRepository;
  final SharedPreferencesRepository sharedPreferences;

  SplashCubit({
    required this.appRepository,
    required this.sharedPreferences,
  }) : super(const SplashInitial());

  checkAuthentication() async {
    emit(const SplashLoading());
    final String authToken = sharedPreferences.getString(authTokenKey);
    final authenticated = authToken.isNotEmpty;
    if (!authenticated) {
      await Future.delayed(const Duration(seconds: 2));
      emit(SplashAuthenticationChecked(authenticated: authenticated));
      return;
    }
    getConfig();
  }

  getConfig() async {
    emit(const SplashLoading());
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    int versionCode = 1;
    try{
      versionCode = int.parse(packageInfo.buildNumber);
    }catch(e){
      debugPrint("versionCode parse exception");
    }
    final result = await appRepository.getConfig(currentVersion: versionCode );
    result.fold(
          (l) => emit(SplashFailed(message: l.message != null ? l.message! : "")),
          (r) async {
        sharedPreferences.setString(appConfigKey, jsonEncode(r.toJson()));
        if (r.appVersion.forceVersionCode > versionCode || r.appVersion.versionCode > versionCode) {
          emit(SplashUpdateNeeded(appVersion: r.appVersion, forceUpdate: r.appVersion.forceVersionCode > versionCode));
        } else {
          emit( SplashLoaded( showUpdateDetailes: r.appVersion.shooUpdateDetailes,description: r.appVersion.Description));
        }
      },
    );
  }
}
