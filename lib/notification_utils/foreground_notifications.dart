import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:spotter/Components/screens/chat/chat_details.dart';
import 'package:spotter/providers/app_state.dart';

registerForLocalNotification() {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('notification_icon');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: true,
  );
  return InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
}

onReceivingLocalNotification(BuildContext context) async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  /// Called when notification sent while app is in open/active state.
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    Map<String, String> data = fetchDataFromMessage(message);
    final InitializationSettings initializationSettings =
        registerForLocalNotification();
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String value) async {
      if (data["topic"] == "spotter-chat") {
        Provider.of<AppState>(context, listen: false)
            .setCurrentRoute("/chat_details");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ChatDetails(
                    data["targetUserName"],
                    "",
                    data["targetUserId"],
                    data["targetUserRole"])));
      }
    });
    if (Provider.of<AppState>(context, listen: false).currentRoute !=
        "/chat_details")
      showInAppNotification(data, flutterLocalNotificationsPlugin, channel);
  });
}

fetchDataFromMessage(RemoteMessage message) {
  Map<String, String> data = {};
  data["topic"] = message.data["topic"];
  if (Platform.isAndroid) {
    data["title"] = message.notification?.title;
    data["body"] = message.notification?.body;
    data["targetUserName"] = message.data["targetUserName"];
    data["targetUserId"] = message.data["targetUserId"];
    data["targetUserRole"] = message.data["targetUserRole"];
    data["scheduleId"] = message.data["scheduleId"];
  } else if (Platform.isIOS) {
    data["title"] = message.notification?.title;
    data["body"] = message.notification?.body;
    data["targetUserName"] = message.data["custom-keys"]["targetUserName"];
    data["targetUserId"] = message.data["custom-keys"]["targetUserId"];
    data["targetUserRole"] = message.data["custom-keys"]["targetUserRole"];
    data["scheduleId"] = message.data["custom-keys"]["scheduleId"];
  }
  return data;
}

showInAppNotification(
    Map<String, String> data,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    AndroidNotificationChannel channel) {
  flutterLocalNotificationsPlugin.show(
      1,
      data["title"],
      data["body"],
      NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            playSound: true,
            groupKey: "group",
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: IOSNotificationDetails(
              presentAlert: true, presentBadge: false, presentSound: false)),
      payload: "payload");
}
