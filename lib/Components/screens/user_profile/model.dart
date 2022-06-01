import 'package:spotter/utils/utils.dart';

Map<String, String> experienceLookup = {
  "sedentary": "I am Sedentary",
  "lightly_active": "I am active 1-2 days/week",
  "active": "I am active 3-5 days/week",
  "very_active": "I am active 5+ days/week"
};
Map<String, String> goalsLookup = {
  "lose_weight": "Lose Weight",
  "increase_strength": "Increase Strength",
  "stay_active": "Stay Active",
  "boost_endurance": "Boost Endurance",
  "improve_flexibility": "Improve Flexibility",
  "tone_musle": "Tone Muscle",
};

class UserDetails {
  String gender = "";
  String experience = "";
  List<String> personalGoals = [];
  List<String> preferredWorkouts = [];
  UserDetails(
      {this.gender,
      this.experience,
      this.personalGoals,
      this.preferredWorkouts});

  UserDetails.fromJson(Map<String, dynamic> onBoardInfo) {
    if (isNotEmpty(onBoardInfo)) {
      gender = onBoardInfo["gender"];
      if (isNotEmpty(onBoardInfo["experience"]))
        experience = experienceLookup[onBoardInfo["experience"]];
      if (isNotEmpty(onBoardInfo["personalGoals"])) {
        onBoardInfo["personalGoals"].forEach((goal) {
          personalGoals.add(goalsLookup[goal]);
        });
      }
      if (isNotEmpty(onBoardInfo["preferredWorkouts"])) {
        onBoardInfo["preferredWorkouts"].forEach((workout) {
          preferredWorkouts.add(workout);
        });
      }
    }
  }
}
