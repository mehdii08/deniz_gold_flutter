import 'dart:convert';

import 'package:deniz_gold/data/dtos/app_config_dto.dart';
import 'package:deniz_gold/data/keys.dart';
import 'package:equatable/equatable.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';//todo fix me
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gold_flutter/data/dtos/app_config_dto.dart'; //todo remove me
import 'package:deniz_gold/domain/repositories/shared_preferences_repository.dart';
import 'package:injectable/injectable.dart';

part 'authentication_state.dart';

const authTokenKey = "auth_token";
const String fcmTokenKey = 'fcmTokenKey';

@lazySingleton
class AuthenticationCubit extends Cubit<AuthenticationState> {
  final SharedPreferencesRepository sharedPreferences;

  AuthenticationCubit({required this.sharedPreferences})
      : super(const AuthenticationInitial());

  bool get isAuthenticated =>
      token != null && token?.isNotEmpty != null ? token!.isNotEmpty : false;

  String? get token => state.token;

  void logOut() async {
    await sharedPreferences.setString(authTokenKey, "");
    emit(UnAuthenticated(dateTime: DateTime.now(), token: token));
  }

  void clearToken() async {
    await sharedPreferences.setString(authTokenKey, "");
  }

  void saveToken(String token) async {
    await sharedPreferences.setString(authTokenKey, token);
    emit(Authenticated(token));
  }

  // String getUserName() {//todo get this from app config cubit
  //   final String appConfigString = sharedPreferences.getString(appConfigKey);
  //   if (appConfigString.isNotEmpty) {
  //     final appConfig = AppConfigDTO.fromJson(jsonDecode(appConfigString));
  //     return appConfig.user.name;
  //   }
  //   return "";
  // }

  storeFCMToken() async {
    //todo
    // final fcmToken = await FirebaseMessaging.instance.getToken();
    // sharedPreferences.setString(fcmTokenKey, fcmToken ?? "empty");
    // FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    //   sharedPreferences.setString(fcmTokenKey, fcmToken);
    // }).onError((err) {/*todo*/});
  }

  AppConfigDTO? getLocalAppConfig(){//todo get this from app config cubit
    final String appConfigString = sharedPreferences.getString(appConfigKey);
    if(appConfigString.isNotEmpty){
      return AppConfigDTO.fromJson(jsonDecode(appConfigString));
    }
    return null;
  }

}
