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

class HavaleNotificationLoaded extends NotificationListenerState {
  final HavaleDTO havaleh;

  HavaleNotificationLoaded({
    required this.havaleh,
  }) : super(dateTime: DateTime.now());

  @override
  List<Object?> get props => [dateTime, havaleh];
}

class TradeResultNotificationLoaded extends NotificationListenerState {
  final TradeResultNotificationEvent tradeResult;

  TradeResultNotificationLoaded({required this.tradeResult}) : super(dateTime: DateTime.now());

  @override
  List<Object?> get props => [dateTime, tradeResult];
}
