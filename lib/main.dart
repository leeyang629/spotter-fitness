import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/app_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message?.notification?.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  Stripe.publishableKey =
      "pk_test_51K4sDJLocyrCH2mHruEZ5cEoT51kxXEQ1I11hshg6R6Dm39g4NCu0K5yA9VCHGcmoUcO5XuUyINL5RcbcoYV0Yyu00ytcIsSyg";
  Stripe.merchantIdentifier = 'merchant.com.camsilu.spotter';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  runApp(ChangeNotifierProvider(
    create: (context) => AppState(),
    child: App(),
  ));
}
