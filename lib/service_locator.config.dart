// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i10;

import 'package:dio/dio.dart' as _i3;
import 'package:firebase_messaging/firebase_messaging.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:package_info_plus/package_info_plus.dart' as _i5;
import 'package:shared_preferences/shared_preferences.dart' as _i6;

import 'core/network/api_helper.dart' as _i12;
import 'core/utils/app_notification_handler.dart' as _i9;
import 'data/data_sources/app_data_source.dart' as _i13;
import 'data/repositories/app_repository_impl.dart' as _i15;
import 'data/repositories/shared_preferences_repository_impl.dart' as _i8;
import 'domain/repositories/app_repository.dart' as _i14;
import 'domain/repositories/shared_preferences_repository.dart' as _i7;
import 'presentation/blocs/account_info/account_info_cubit.dart' as _i33;
import 'presentation/blocs/app_config/app_config_cubit.dart' as _i34;
import 'presentation/blocs/auth/authentication_cubit.dart' as _i11;
import 'presentation/blocs/balance/balance_cubit.dart' as _i16;
import 'presentation/blocs/check_mobile/check_mobile_cubit.dart' as _i17;
import 'presentation/blocs/forgetPassword/forget_password_cubit.dart' as _i18;
import 'presentation/blocs/havale/havale_cubit.dart' as _i19;
import 'presentation/blocs/havlehOwner/havaleh_owner_cubit.dart' as _i20;
import 'presentation/blocs/home/home_screen_cubit.dart' as _i21;
import 'presentation/blocs/login/login_cubit.dart' as _i22;
import 'presentation/blocs/notification_listener/notification_listener_cubit.dart'
    as _i23;
import 'presentation/blocs/profile/profile_cubit.dart' as _i24;
import 'presentation/blocs/register/register_cubit.dart' as _i25;
import 'presentation/blocs/reset_password/reset_password_cubit.dart' as _i26;
import 'presentation/blocs/splash/splash_cubit.dart' as _i27;
import 'presentation/blocs/support/support_cubit.dart' as _i28;
import 'presentation/blocs/trade/trade_cubit.dart' as _i29;
import 'presentation/blocs/trades/trades_cubit.dart' as _i30;
import 'presentation/blocs/transactions/transactions_cubit.dart' as _i31;
import 'presentation/blocs/verify_mobile/verify_mobile_cubit.dart' as _i32;
import 'service_locator.dart' as _i35; // ignore_for_file: unnecessary_lambdas

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
  await gh.singletonAsync<_i5.PackageInfo>(
    () => registerModule.resolvePackageInfo,
    preResolve: true,
  );
  await gh.singletonAsync<_i6.SharedPreferences>(
    () => registerModule.resolveSharedPreferences,
    preResolve: true,
  );
  gh.lazySingleton<_i7.SharedPreferencesRepository>(() =>
      _i8.SharedPreferencesRepositoryImpl(
          sharedPreferences: get<_i6.SharedPreferences>()));
  gh.lazySingleton<Sink<_i9.AppNotificationEvent>>(
      () => registerModule.resolveDataUpdateEventSink);
  gh.lazySingleton<_i10.Stream<_i9.AppNotificationEvent>>(
      () => registerModule.resolveDataUpdateEventStream);
  gh.factory<_i10.StreamController<_i9.AppNotificationEvent>>(
      () => registerModule.dataUpdateController);
  gh.lazySingleton<_i11.AuthenticationCubit>(() => _i11.AuthenticationCubit(
      sharedPreferences: get<_i7.SharedPreferencesRepository>()));
  gh.lazySingleton<_i12.ApiHelper>(() => _i12.ApiHelper(
        dio: get<_i3.Dio>(),
        authenticationCubit: get<_i11.AuthenticationCubit>(),
      ));
  gh.lazySingleton<_i13.AppDataSource>(
      () => _i13.AppDataSourceImpl(get<_i12.ApiHelper>()));
  gh.lazySingleton<_i14.AppRepository>(
      () => _i15.AppRepositoryImpl(dataSource: get<_i13.AppDataSource>()));
  gh.factory<_i16.BalanceCubit>(
      () => _i16.BalanceCubit(appRepository: get<_i14.AppRepository>()));
  gh.factory<_i17.CheckMobileCubit>(
      () => _i17.CheckMobileCubit(get<_i14.AppRepository>()));
  gh.factory<_i18.ForgetPasswordCubit>(
      () => _i18.ForgetPasswordCubit(get<_i14.AppRepository>()));
  gh.factory<_i19.HavaleCubit>(() => _i19.HavaleCubit(
        appRepository: get<_i14.AppRepository>(),
        appNotificationEvents: get<_i10.Stream<_i9.AppNotificationEvent>>(),
        sharedPreferences: get<_i7.SharedPreferencesRepository>(),
      ));
  gh.factory<_i20.HavalehOwnerCubit>(
      () => _i20.HavalehOwnerCubit(appRepository: get<_i14.AppRepository>()));
  gh.factory<_i21.HomeScreenCubit>(() => _i21.HomeScreenCubit(
        appRepository: get<_i14.AppRepository>(),
        appNotificationEvents: get<_i10.Stream<_i9.AppNotificationEvent>>(),
      ));
  gh.factory<_i22.LoginCubit>(() => _i22.LoginCubit(
        appRepository: get<_i14.AppRepository>(),
        sharedPreferences: get<_i7.SharedPreferencesRepository>(),
      ));
  gh.lazySingleton<_i23.NotificationListenerCubit>(
      () => _i23.NotificationListenerCubit(
            appRepository: get<_i14.AppRepository>(),
            sharedPreferences: get<_i7.SharedPreferencesRepository>(),
            appNotificationEvents: get<_i10.Stream<_i9.AppNotificationEvent>>(),
          ));
  gh.factory<_i24.ProfileCubit>(() => _i24.ProfileCubit(
        appRepository: get<_i14.AppRepository>(),
        sharedPreferences: get<_i7.SharedPreferencesRepository>(),
      ));
  gh.factory<_i25.RegisterCubit>(
      () => _i25.RegisterCubit(get<_i14.AppRepository>()));
  gh.factory<_i26.ResetPasswordCubit>(
      () => _i26.ResetPasswordCubit(get<_i14.AppRepository>()));
  gh.factory<_i27.SplashCubit>(() => _i27.SplashCubit(
        appRepository: get<_i14.AppRepository>(),
        sharedPreferences: get<_i7.SharedPreferencesRepository>(),
      ));
  gh.factory<_i28.SupportCubit>(
      () => _i28.SupportCubit(appRepository: get<_i14.AppRepository>()));
  gh.factory<_i29.TradeCubit>(() => _i29.TradeCubit(
        appRepository: get<_i14.AppRepository>(),
        appNotificationEvents: get<_i10.Stream<_i9.AppNotificationEvent>>(),
        sharedPreferences: get<_i7.SharedPreferencesRepository>(),
      ));
  gh.factory<_i30.TradesCubit>(
      () => _i30.TradesCubit(get<_i14.AppRepository>()));
  gh.factory<_i31.TransactionsCubit>(
      () => _i31.TransactionsCubit(get<_i14.AppRepository>()));
  gh.factory<_i32.VerifyMobileCubit>(() => _i32.VerifyMobileCubit(
        appRepository: get<_i14.AppRepository>(),
        sharedPreferences: get<_i7.SharedPreferencesRepository>(),
      ));
  gh.factory<_i33.AccountInfoCubit>(
      () => _i33.AccountInfoCubit(get<_i14.AppRepository>()));
  gh.lazySingleton<_i34.AppConfigCubit>(() => _i34.AppConfigCubit(
        appRepository: get<_i14.AppRepository>(),
        sharedPreferences: get<_i7.SharedPreferencesRepository>(),
        appNotificationEvents: get<_i10.Stream<_i9.AppNotificationEvent>>(),
      ));
  return get;
}

class _$RegisterModule extends _i35.RegisterModule {}
