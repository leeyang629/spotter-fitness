class ScheduleDetails {
  String startTime;
  String startHr;
  String startMeridian;
  String endTime;
  String status;
  String userPermalink;
  String trainerPermalink;
  String trainWith;
  String durationHr;
  String durationMin;
  String workout;
  String secretCode;

  ScheduleDetails.fromJSON(Map<String, dynamic> json, String target) {
    startTime = json["start_time"];
    final hr = int.parse(startTime.split('T')[1].split(":")[0]);
    final min = startTime.split('T')[1].split(":")[1];
    startHr = hr > 12 ? '${(hr - 12)}:$min' : '$hr:$min';
    startMeridian = hr > 12 ? 'PM' : 'AM';
    endTime = json["end_time"];
    status = json["status"];
    userPermalink = json["user_permalink"];
    trainerPermalink = json["trainer_permalink"];
    if (target == "user") {
      trainWith = json["user_first_name"];
    }
    if (target == "trainer") {
      trainWith = json["trainer_first_name"];
    }
    durationHr = json["duration"]["hour"];
    durationMin = json["duration"]["min"];
    if (json["other_informations"] != null) {
      workout = json["other_informations"]["workout_type"];
    }
    secretCode = json["secret"].toString();
  }
}
