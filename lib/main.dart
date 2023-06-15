import 'package:deniz_gold/core/utils/app_notification_handler.dart';
import 'package:deniz_gold/firebase_options.dart';
import 'package:deniz_gold/presentation/deniz_app.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool isInTradeScreen = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSL();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final notificationEventSink = sl<Sink<AppNotificationEvent>>();
  if(kIsWeb){
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }


  if (!kIsWeb) await FirebaseMessaging.instance.subscribeToTopic("all");
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('----------> Message data: ${message.data}');

    if (message.data['type'] == tradeResultNotificationType) {
      notificationEventSink.add(TradeResultNotificationEvent.fromJson(message.data));
    } else if (message.data['type'] == homeDataNotificationType) {
      notificationEventSink.add(HomeDataNotificationEvent.fromJson(message.data));
    } else if (message.data['type'] == botStatusNotificationType) {
      notificationEventSink.add(BotStatusDataNotificationEvent.fromJson(message.data));
    } else if (message.data['type'] == havalehStatusNotificationType) {
      notificationEventSink.add(HavalehStatusNotificationEvent.fromJson(message.data));
    }
  });
  runApp(const DenizApp());
}
