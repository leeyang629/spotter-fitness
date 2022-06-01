class ScheduleCardDetails {
  int id;
  String date = '';
  String startTime = '';
  String endTime = '';
  String status = '';
  String trainWith = "";
  String workout;
  ScheduleCardDetails(
      this.startTime, this.endTime, this.status, this.trainWith, this.workout);

  ScheduleCardDetails.fromJSON(Map<String, dynamic> json, String target) {
    id = json["id"];
    if (json["start_time"] != null) {
      date = json["start_time"].split("T")[0];
      startTime = json["start_time"].split("T")[1];
    }
    endTime = json["end_time"];
    if (json['status'] != null) {
      status = json['status'];
    }
    if (target == "user") {
      trainWith = json['user_first_name'];
    }
    if (target == "trainer") {
      trainWith = json['trainer_first_name'];
    }
    if (json["other_informations"] != null) {
      workout = json["other_informations"]["workout_type"];
    }
  }

  static List<ScheduleCardDetails> parseSchedules(List list, String target) {
    return list
        .map((schedule) => ScheduleCardDetails.fromJSON(schedule, target))
        .toList();
  }
}
