part of 'app_config_cubit.dart';

abstract class AppConfigState extends Equatable {
  final AppConfigDTO? appConfig;
  final DateTime dateTime;
  final bool needUpdate;

  const AppConfigState({
    required this.appConfig,
    required this.dateTime,
    this.needUpdate = false,
  });

  @override
  List<Object?> get props => [appConfig, dateTime];
}

class AppConfigInitial extends AppConfigState {
  AppConfigInitial() : super(appConfig: null, dateTime: DateTime.now());
}

class AppConfigLoading extends AppConfigState {
  AppConfigLoading({
    required AppConfigDTO? appConfig,
  }) : super(appConfig: appConfig, dateTime: DateTime.now());
}

class AppConfigLoaded extends AppConfigState {
  AppConfigLoaded({
    required AppConfigDTO appConfig,
    bool needUpdate = false,
  }) : super(
          appConfig: appConfig,
          dateTime: DateTime.now(),
          needUpdate: needUpdate,
        );
}

class AppConfigFailed extends AppConfigState {
  final String message;

  AppConfigFailed({
    required this.message,
    required AppConfigDTO appConfig,
  }) : super(appConfig: appConfig, dateTime: DateTime.now());

  @override
  List<Object?> get props => [appConfig, dateTime, message];
}
