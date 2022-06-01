import 'package:spotter/Components/screens/trainer_profile/model.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/core/http.dart';

Future<TrainerDetails> getTrainerDetails(String permalink) async {
  final api = HttpClient(productionApiUrls.user);
  try {
    if (permalink != "" || permalink != null) {
      final result =
          await api.get("/api/v1/users/$permalink", withAuthHeaders: true);
      print(result);
      TrainerDetails details = TrainerDetails.fromJson(result["user"]);
      return details;
    }
    return new TrainerDetails();
  } catch (e) {
    print(e);
    return Future.error(e.toString());
  }
}

followApi(String permalink, Function updateHandler) async {
  try {
    final api = HttpClient(productionApiUrls.user);
    final result =
        await api.post("/follow/$permalink", {}, withAuthHeaders: true);
    if (result['statusCode'] == 200)
      updateHandler(true);
    else
      updateHandler(false);
  } catch (e) {
    print('error - $e');
    updateHandler(false);
  }
}

unFollowApi(String permalink, Function updateHandler) async {
  try {
    final api = HttpClient(productionApiUrls.user);
    final result =
        await api.post("/unfollow/$permalink", {}, withAuthHeaders: true);
    if (result['statusCode'] == 200)
      updateHandler(false);
    else
      updateHandler(true);
  } catch (e) {
    print('error - $e');
    updateHandler(true);
  }
}
