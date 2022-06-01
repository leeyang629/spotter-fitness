import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/Components/screens/chat/chat_details.dart';
import 'package:spotter/providers/app_state.dart';

onBackgroundNotificationClick(BuildContext context) {
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    Map<String, String> data = fetchDataFromMessage(message);
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
    } else if (data["topic"] == "spotter-appointment-new") {
      Navigator.pushNamed(context, "/schedule_details",
          arguments: {"id": data["scheduleId"]});
    }
  });
}

fetchDataFromMessage(RemoteMessage message) {
  Map<String, String> data = {};
  data["topic"] = message.data["topic"];
  if (Platform.isAndroid) {
    data["targetUserName"] = message.data["targetUserName"];
    data["targetUserId"] = message.data["targetUserId"];
    data["targetUserRole"] = message.data["targetUserRole"];
    data["scheduleId"] = message.data["scheduleId"];
  } else if (Platform.isIOS) {
    data["targetUserName"] = message.data["custom-keys"]["targetUserName"];
    data["targetUserId"] = message.data["custom-keys"]["targetUserId"];
    data["targetUserRole"] = message.data["custom-keys"]["targetUserRole"];
    data["scheduleId"] = message.data["custom-keys"]["scheduleId"];
  }
  return data;
}
