import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pubnub/pubnub.dart';
import 'package:spotter/core/storage.dart';
import 'package:spotter/utils/chat_subscription.dart';
import 'package:spotter/utils/permissions.dart';
import 'package:spotter/utils/utils.dart';

registerForNotifications(BuildContext context) async {
  final allowed = await getNotificationPermission();
  if (allowed) {
    final SecureStorage storage = SecureStorage();
    final userPermalink = await storage.getPermalink();
    if (isNotEmpty(userPermalink)) {
      PubNub pubnub = initiatePubNub(userPermalink);
      FirebaseMessaging messaging;
      messaging = FirebaseMessaging.instance;
      if (Platform.isAndroid) {
        messaging.getToken().then((deviceToken) async {
          await subscribeToChannel(userPermalink, pubnub);
          print(deviceToken);
          pubnub.addPushChannels(
              deviceToken, PushGateway.gcm, {'$userPermalink-dummy'});
        });
      }
      if (Platform.isIOS) {
        messaging.getAPNSToken().then((deviceToken) async {
          await subscribeToChannel(userPermalink, pubnub);
          print("devicetoken");
          print(deviceToken);
          if (isNotEmpty(deviceToken))
            pubnub.addPushChannels(
                deviceToken, PushGateway.apns2, {'$userPermalink-dummy'},
                topic: "com.camsilu.spotter",
                environment: Environment.development);
        });
      }
    }
  }
}
