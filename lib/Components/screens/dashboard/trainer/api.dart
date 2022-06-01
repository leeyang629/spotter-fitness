import 'package:flutter/material.dart';
import 'package:spotter/Components/screens/dashboard/trainer/model.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/core/http.dart';

fetchTrainerMetrics(BuildContext context, String timeSpan) async {
  final api = HttpClient(productionApiUrls.user);
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
    case '15days':
      duration = Duration(days: 15);
      extract = "day";
      break;
    default:
      duration = Duration(days: 30);
      break;
  }
  try {
    final result = await api.get(
        "/metrics?start=${DateTime.now().subtract(duration).toString().substring(0, 16)}&finish=${DateTime.now().toString().substring(0, 16)}&extract=$extract",
        withAuthHeaders: true);
    return result;
  } catch (e) {
    print("error");
    print(e);
  }
}

Future<ScheduleDetails> fetchDetails(int id) async {
  final api = HttpClient(productionApiUrls.user);
  try {
    final result = await api.get("/appointments/$id", withAuthHeaders: true);

    print(result);
    return ScheduleDetails.fromJSON(result, "user");
  } catch (e) {
    print("error - $e");
    return Future.error(e.toString());
  }
}
