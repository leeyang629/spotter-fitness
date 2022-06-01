import 'package:spotter/utils/utils.dart';

class TrainerData {
  String name = "";
  String imageUrl = "";
  List<dynamic> specialization = [];
  String permalink = "";
  double distance = 0;
  int percentageMatch = 0;

  TrainerData(this.name, this.imageUrl, this.specialization, this.permalink,
      this.distance, this.percentageMatch);
  factory TrainerData.fromJSON(
      Map<String, dynamic> json, int distance, List<String> userPreferences) {
    double match = 0;
    if ((userPreferences ?? []).length == 0 ||
        (json["specialization"] ?? []).length == 0) {
      match = 0;
    } else {
      int common = 0;
      userPreferences.forEach((element) {
        if (json["specialization"].contains(element)) {
          common++;
        }
      });
      match = ((common / userPreferences.length) * 100);
    }
    return TrainerData(
        json["firstName"],
        json["imageURL"] ?? "",
        json["specialization"] ?? [],
        json["permalink"],
        roundToDecimalPlaces(distance * 0.000621, 1),
        match.round());
  }

  static List<TrainerData> parseTrainers(
      List list, List<String> userPreferences) {
    return list
        .map((trainer) => TrainerData.fromJSON(
            trainer["trainer"], (trainer["distance"] ?? 0), userPreferences))
        .toList();
  }
}
