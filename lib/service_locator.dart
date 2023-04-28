import 'dart:async';

import 'package:dio/dio.dart';
// import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:get_it/get_it.dart';
import 'package:deniz_gold/core/network/interceptor.dart';
import 'package:deniz_gold/core/network/transformers.dart';
// import 'package:deniz_gold/core/utils/app_notification_handler.dart';//todo fix me
import 'package:deniz_gold/core/utils/config.dart';
import 'package:deniz_gold/service_locator.config.dart';
import 'package:injectable/injectable.dart';
// import 'package:shared_preferences/shared_preferences.dart';//todo fix me

final sl = GetIt.I;

@InjectableInit()
Future initSL() async {
  await $initGetIt(sl);
  sl<Dio>().interceptors.addAll([
    // AppInterceptor(authenticationCubit: sl(), sharedPreferences: sl()),//todo fix me
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

// Future<SharedPreferences> getSharedPreferences() async {//todo fix me
//   return await SharedPreferences.getInstance();
// }

Future<String> getUserAgent() async {
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
  // late final dataUpdateController =
  // StreamController<AppNotificationEvent>.broadcast();//todo fix me

  @singleton
  @preResolve
  Future<Dio> get resolveDio => getDio();

  // @singleton
  // @preResolve
  // Future<SharedPreferences> get resolveSharedPreferences => getSharedPreferences();//todo fix me

  // @lazySingleton
  // Sink<AppNotificationEvent> get resolveDataUpdateEventSink => dataUpdateController;//todo fix me

  // @lazySingleton
  // Stream<AppNotificationEvent> get resolveDataUpdateEventStream =>//todo fix me
  //     dataUpdateController.stream;

}