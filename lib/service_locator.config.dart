// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i9;

import 'package:dio/dio.dart' as _i3;
import 'package:firebase_messaging/firebase_messaging.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i5;

import 'core/network/api_helper.dart' as _i11;
import 'core/utils/app_notification_handler.dart' as _i8;
import 'data/data_sources/app_data_source.dart' as _i12;
import 'data/repositories/app_repository_impl.dart' as _i14;
import 'data/repositories/shared_preferences_repository_impl.dart' as _i7;
import 'domain/repositories/app_repository.dart' as _i13;
import 'domain/repositories/shared_preferences_repository.dart' as _i6;
import 'presentation/blocs/app_config/app_config_cubit.dart' as _i22;
import 'presentation/blocs/auth/authentication_cubit.dart' as _i10;
import 'presentation/blocs/check_mobile/check_mobile_cubit.dart' as _i15;
import 'presentation/blocs/forgetPassword/forget_password_cubit.dart' as _i16;
import 'presentation/blocs/login/login_cubit.dart' as _i17;
import 'presentation/blocs/register/register_cubit.dart' as _i18;
import 'presentation/blocs/reset_password/reset_password_cubit.dart' as _i19;
import 'presentation/blocs/splash/splash_cubit.dart' as _i20;
import 'presentation/blocs/verify_mobile/verify_mobile_cubit.dart' as _i21;
import 'service_locator.dart' as _i23; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  await gh.singletonAsync<_i3.Dio>(
    () => registerModule.resolveDio,
    preResolve: true,
  );
  gh.lazySingleton<_i4.FirebaseMessaging>(
      () => registerModule.resolveFirebaseMessaging);
  await gh.singletonAsync<_i5.SharedPreferences>(
    () => registerModule.resolveSharedPreferences,
    preResolve: true,
  );
  gh.lazySingleton<_i6.SharedPreferencesRepository>(() =>
      _i7.SharedPreferencesRepositoryImpl(
          sharedPreferences: get<_i5.SharedPreferences>()));
  gh.lazySingleton<Sink<_i8.AppNotificationEvent>>(
      () => registerModule.resolveDataUpdateEventSink);
  gh.lazySingleton<_i9.Stream<_i8.AppNotificationEvent>>(
      () => registerModule.resolveDataUpdateEventStream);
  gh.factory<_i9.StreamController<_i8.AppNotificationEvent>>(
      () => registerModule.dataUpdateController);
  gh.lazySingleton<_i10.AuthenticationCubit>(() => _i10.AuthenticationCubit(
      sharedPreferences: get<_i6.SharedPreferencesRepository>()));
  gh.lazySingleton<_i11.ApiHelper>(() => _i11.ApiHelper(
        dio: get<_i3.Dio>(),
        authenticationCubit: get<_i10.AuthenticationCubit>(),
      ));
  gh.lazySingleton<_i12.AppDataSource>(
      () => _i12.AppDataSourceImpl(get<_i11.ApiHelper>()));
  gh.lazySingleton<_i13.AppRepository>(
      () => _i14.AppRepositoryImpl(dataSource: get<_i12.AppDataSource>()));
  gh.factory<_i15.CheckMobileCubit>(
      () => _i15.CheckMobileCubit(get<_i13.AppRepository>()));
  gh.factory<_i16.ForgetPasswordCubit>(
      () => _i16.ForgetPasswordCubit(get<_i13.AppRepository>()));
  gh.factory<_i17.LoginCubit>(() => _i17.LoginCubit(
        appRepository: get<_i13.AppRepository>(),
        sharedPreferences: get<_i6.SharedPreferencesRepository>(),
      ));
  gh.factory<_i18.RegisterCubit>(
      () => _i18.RegisterCubit(get<_i13.AppRepository>()));
  gh.factory<_i19.ResetPasswordCubit>(
      () => _i19.ResetPasswordCubit(get<_i13.AppRepository>()));
  gh.factory<_i20.SplashCubit>(() => _i20.SplashCubit(
        appRepository: get<_i13.AppRepository>(),
        sharedPreferences: get<_i6.SharedPreferencesRepository>(),
      ));
  gh.factory<_i21.VerifyMobileCubit>(() => _i21.VerifyMobileCubit(
        appRepository: get<_i13.AppRepository>(),
        sharedPreferences: get<_i6.SharedPreferencesRepository>(),
      ));
  gh.lazySingleton<_i22.AppConfigCubit>(() => _i22.AppConfigCubit(
        appRepository: get<_i13.AppRepository>(),
        sharedPreferences: get<_i6.SharedPreferencesRepository>(),
        appNotificationEvents: get<_i9.Stream<_i8.AppNotificationEvent>>(),
      ));
  return get;
}

class _$RegisterModule extends _i23.RegisterModule {}
