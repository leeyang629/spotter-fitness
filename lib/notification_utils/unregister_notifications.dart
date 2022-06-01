import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pubnub/pubnub.dart';
import 'package:spotter/core/storage.dart';
import 'package:spotter/utils/chat_subscription.dart';
import 'package:spotter/utils/utils.dart';

unRegsiterNotifications() async {
  print("unregistering");
  final SecureStorage storage = SecureStorage();
  final userPermalink = await storage.getPermalink();
  PubNub pubnub = initiatePubNub(userPermalink);
  FirebaseMessaging messaging;
  messaging = FirebaseMessaging.instance;
  if (Platform.isAndroid) {
    print("Its android");
    messaging.getToken().then((deviceToken) {
      print(deviceToken);
      pubnub.removePushChannels(
          deviceToken, PushGateway.gcm, {'$userPermalink-dummy'});
    });
  }
  if (Platform.isIOS) {
    messaging.getAPNSToken().then((deviceToken) {
      print(deviceToken);
      if (isNotEmpty(deviceToken))
        pubnub.removePushChannels(
            deviceToken, PushGateway.apns2, {'$userPermalink-dummy'},
            topic: "com.camsilu.spotter", environment: Environment.development);
    });
  }
  await storage.deleteUserData();
}
