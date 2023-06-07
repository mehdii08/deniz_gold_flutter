part of 'notification_listener_cubit.dart';

abstract class NotificationListenerState extends Equatable {
  final DateTime dateTime;

  const NotificationListenerState({
    required this.dateTime,
  });

  @override
  List<Object?> get props => [dateTime];
}

class NotificationListenerInitial extends NotificationListenerState {
  NotificationListenerInitial() : super(dateTime: DateTime.now());
}

class NotificationListenerLoaded extends NotificationListenerState {
  final HavaleDTO havaleh;

  NotificationListenerLoaded({
    required this.havaleh,
  }) : super(dateTime: DateTime.now());

  @override
  List<Object?> get props => [dateTime, havaleh];
}
