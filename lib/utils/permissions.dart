import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';

Future<Position> getPermission() async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    print("Do we have permission? : " + permission.toString());

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return Position(longitude: -122.406417, latitude: 37.785834);

        /// returning a default location
      }
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        print(
            'Location permissions are permanently denied, we cannot request permissions.');
        return Position(longitude: -122.406417, latitude: 37.785834);

        /// returning a default location
      }
    }
    return await Geolocator.getCurrentPosition();
  } catch (e) {
    print(e);
    return Position(longitude: -122.406417, latitude: 37.785834);
  }
}

Future<bool> getNotificationPermission() async {
  if (Platform.isIOS) {
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
      return true;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
      return true;
    } else {
      print('User declined or has not accepted permission');
      return false;
    }
  } else if (Platform.isAndroid) return true;
  return false;
}
