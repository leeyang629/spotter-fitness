import 'dart:math';

import 'package:url_launcher/url_launcher.dart';

isNotEmpty(dynamic value) {
  return value != null && value != {} && value != [] && value != "";
}

Future<void> launchUrl(String url) async {
  if (url != null && url != "") await launch(url);
}

roundToDecimalPlaces(double val, int places) {
  num mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
}
