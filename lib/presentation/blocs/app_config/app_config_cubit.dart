import 'dart:convert';

import 'package:deniz_gold/data/dtos/app_config_dto.dart';
import 'package:deniz_gold/data/keys.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/core/utils/app_notification_handler.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:deniz_gold/domain/repositories/shared_preferences_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'app_config_state.dart';

const authTokenKey = "auth_token";
const String fcmTokenKey = 'fcmTokenKey';

@lazySingleton
class AppConfigCubit extends Cubit<AppConfigState> {
  final AppRepository appRepository;
  final SharedPreferencesRepository sharedPreferences;
  final Stream<AppNotificationEvent> appNotificationEvents;

  AppConfigCubit({
    required this.appRepository,
    required this.sharedPreferences,
    required this.appNotificationEvents,
  }) : super(AppConfigInitial()) {
    appNotificationEvents.listen((event) {
      if (event is BotStatusDataNotificationEvent && state.appConfig != null) {
        final newConfig = state.appConfig!.update(newLogo: event.logo, newBotStatus: event.botStatus);
        emit(AppConfigLoaded(appConfig: newConfig));
      }
    });
    final String appConfigString = sharedPreferences.getString(appConfigKey);
    if (appConfigString.isNotEmpty) {
      final appConfig = AppConfigDTO.fromJson(jsonDecode(appConfigString));
      emit(AppConfigLoaded(appConfig: appConfig));
      getConfig();
    }
  }

  getConfig() async {
    emit(AppConfigLoading(appConfig: state.appConfig));
    final result = await appRepository.getConfig();
    result.fold(
      (l) {
      },
      (r) async {
        sharedPreferences.setString(appConfigKey, jsonEncode(r.toJson()));
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String version = packageInfo.version;
        emit(AppConfigLoaded(appConfig: r, needUpdate: r.appVersion.version != version));
      },
    );
  }

  reset() => emit(AppConfigInitial());
}
