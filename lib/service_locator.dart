import 'dart:async';

import 'package:deniz_gold/core/utils/app_notification_handler.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:get_it/get_it.dart';
import 'package:deniz_gold/core/network/interceptor.dart';
import 'package:deniz_gold/core/network/transformers.dart';
import 'package:deniz_gold/core/utils/config.dart';
import 'package:deniz_gold/service_locator.config.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.I;

@InjectableInit()
Future initSL() async {
  await $initGetIt(sl);
  sl<Dio>().interceptors.addAll([
    AppInterceptor(authenticationCubit: sl(), sharedPreferences: sl()),
    LogInterceptor(responseBody: true, requestBody: true),
  ]);
}

Future<Dio> getDio() async {
  final options = BaseOptions(
    baseUrl: serverUrl,
    headers: {
      'User-Agent': await getUserAgent(),
      // 'version': FkUserAgent.getProperty('applicationVersion'),
    },
  );
  return Dio(options)..transformer = AsyncDataTransformer();
}

Future<SharedPreferences> getSharedPreferences() async {
  return await SharedPreferences.getInstance();
}

Future<String> getUserAgent() async {//todo fix me
  try {
    // final userAgent = await FkUserAgent.getPropertyAsync('userAgent');
    // return '${FkUserAgent.getProperty('applicationName')}/${FkUserAgent.getProperty('applicationVersion')} $userAgent';
    // return 'aghigh/${FkUserAgent.getProperty('applicationVersion')} $userAgent';
  } catch (e) {
    return '';
  }
  return '';
}

@module
abstract class RegisterModule{
  late final dataUpdateController =
  StreamController<AppNotificationEvent>.broadcast();

  @singleton
  @preResolve
  Future<Dio> get resolveDio => getDio();

  @singleton
  @preResolve
  Future<SharedPreferences> get resolveSharedPreferences => getSharedPreferences();

  @lazySingleton
  FirebaseMessaging get resolveFirebaseMessaging => FirebaseMessaging.instance;

  @lazySingleton
  Sink<AppNotificationEvent> get resolveDataUpdateEventSink => dataUpdateController;

  @lazySingleton
  Stream<AppNotificationEvent> get resolveDataUpdateEventStream =>
      dataUpdateController.stream;

}