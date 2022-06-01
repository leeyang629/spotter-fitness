import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/Components/common/dialog.dart';
import 'package:spotter/Components/common/scheduleCard.dart';
import 'package:spotter/Components/screens/chat/chat_details.dart';
import 'package:spotter/Components/screens/dashboard/trainer/api.dart';
import 'package:spotter/Components/screens/dashboard/trainer/model.dart';
import 'package:spotter/Components/screens/schedule/model.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/core/http.dart';
import 'package:spotter/core/storage.dart';
import 'package:spotter/providers/app_state.dart';

class TrainerSchedule extends StatefulWidget {
  @override
  ComponentState createState() => ComponentState();
}

class ComponentState extends State<TrainerSchedule> {
  List<ScheduleCardDetails> schedules = [];
  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: schedules
            .map<Widget>((schedule) =>
                scheduleCard(schedule, actions2: true, approve: () {
                  approve(schedule.id);
                }, startSession: () {
                  startSession(schedule.id);
                }, endSession: () {
                  endSession(schedule.id);
                }, chatWith: () {
                  chatWith(schedule.id);
                }))
            .toList());
  }

  chatWith(int id) async {
    ScheduleDetails details = await fetchDetails(id);
    Provider.of<AppState>(context, listen: false)
        .setCurrentRoute("/chat_details");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ChatDetails(
                details.trainWith, "", details.userPermalink, "user")));
  }

  Future approve(id) async {
    final result = await Navigator.pushNamed(context, "/schedule_details",
        arguments: {"id": id});
    fetchEvents();
  }

  Future startSession(id) async {
    final result = await Navigator.pushNamed(context, "/start_session",
        arguments: {"id": id});
    fetchEvents();
  }

  Future endSession(int id) async {
    popupDialog(
        context, "Appointment", "Are you sure you want to end the session?", [
      TextButton(
        child: Text("Back"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      TextButton(
        child: Text("Confirm"),
        onPressed: () {
          confirmEndSession(id);
          Navigator.of(context).pop();
        },
      )
    ]);
  }

  Future confirmEndSession(int id) async {
    final api = HttpClient(productionApiUrls.user);
    try {
      Provider.of<AppState>(context, listen: false).enableSpinner();
      final result = await api.post("/session_completed?id=$id", {},
          withAuthHeaders: true);
      print(result);
      await fetchEvents();
      Provider.of<AppState>(context, listen: false).disableSpinner();
    } catch (e) {
      print("error - $e");
      Provider.of<AppState>(context, listen: false).disableSpinner();
    }
  }

  Future fetchEvents() async {
    final api = HttpClient(productionApiUrls.user);
    final SecureStorage storage = SecureStorage();
    String permalink = await storage.getPermalink();
    try {
      final result = await api.get("/appointments?trainer_permalink=$permalink",
          withAuthHeaders: true);

      print(result);
      final data = ScheduleCardDetails.parseSchedules(
          result["bookedAppointments"], "user");
      if (data.length > 0) {
        setState(() {
          schedules = data;
        });
      }
    } catch (e) {
      print("error - $e");
    }
  }
}
