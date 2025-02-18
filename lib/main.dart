import 'package:deniz_gold/core/utils/app_notification_handler.dart';
import 'package:deniz_gold/firebase_options.dart';
import 'package:deniz_gold/presentation/deniz_app.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool tradeWaitingDialogIsOnTop = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSL();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final notificationEventSink = sl<Sink<AppNotificationEvent>>();

  if (!kIsWeb) {
    await FirebaseMessaging.instance.subscribeToTopic("all");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('----------> Message data: ${message.data}');

      if (message.data['type'] == tradeResultNotificationType) {
        notificationEventSink.add(TradeResultNotificationEvent.fromJson(message.data));
      } else if (message.data['type'] == coinsPriceNotificationType) {
        notificationEventSink.add(CoinsPriceNotificationEvent.fromJson(message.data));
      } else if (message.data['type'] == homeDataNotificationType) {
        notificationEventSink.add(HomeDataNotificationEvent.fromJson(message.data));
      } else if (message.data['type'] == botStatusNotificationType) {
        notificationEventSink.add(BotStatusDataNotificationEvent.fromJson(message.data));
      } else if (message.data['type'] == havalehStatusNotificationType) {
        notificationEventSink.add(HavalehStatusNotificationEvent.fromJson(message.data));
      }
    });
  }
  runApp(const DenizApp());
}
