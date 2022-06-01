import 'package:flutter/material.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/core/http.dart';
import 'package:spotter/core/storage.dart';

fetchGymMetrics(BuildContext context, String timeSpan) async {
  final api = HttpClient(productionApiUrls.company);
  final storage = SecureStorage();
  final companyPermalink = await storage.getCompanyPermalink();
  String extract = "";
  Duration duration;
  switch (timeSpan.toLowerCase()) {
    case 'day':
      duration = Duration(days: 1);
      extract = "day";
      break;
    case 'month':
      duration = Duration(days: 30);
      extract = "month";
      break;
    default:
      duration = Duration(days: 30);
      extract = "day";
      break;
  }
  try {
    final result = await api.get(
        "/metrics?start=${DateTime.now().subtract(duration).toString().substring(0, 16)}&finish=${DateTime.now().toString().substring(0, 16)}&permalink=$companyPermalink&extract=$extract",
        withAuthHeaders: true);
    return result;
  } catch (e) {
    print("error");
    print(e);
  }
}
