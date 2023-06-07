import 'package:deniz_gold/core/utils/app_notification_handler.dart';
import 'package:deniz_gold/data/dtos/havale_dto.dart';
import 'package:deniz_gold/domain/repositories/app_repository.dart';
import 'package:deniz_gold/domain/repositories/shared_preferences_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'notification_listener_state.dart';

const authTokenKey = "auth_token";
const String fcmTokenKey = 'fcmTokenKey';

@lazySingleton
class NotificationListenerCubit extends Cubit<NotificationListenerState> {
  final AppRepository appRepository;
  final SharedPreferencesRepository sharedPreferences;
  final Stream<AppNotificationEvent> appNotificationEvents;

  NotificationListenerCubit({
    required this.appRepository,
    required this.sharedPreferences,
    required this.appNotificationEvents,
  }) : super(NotificationListenerInitial()) {
    appNotificationEvents.listen((event) {
      if (event is HavalehStatusNotificationEvent) {
        emit(NotificationListenerLoaded(havaleh: event.havaleh));
      }
    });
  }
}
