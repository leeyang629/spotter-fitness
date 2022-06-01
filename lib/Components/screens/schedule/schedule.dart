import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/Components/common/LoadingIndicator.dart';
import 'package:spotter/Components/common/dialog.dart';
import 'package:spotter/Components/common/scheduleCard.dart';
import 'package:spotter/Components/screens/chat/chat_details.dart';
import 'package:spotter/Components/screens/dashboard/trainer/model.dart';
import 'package:spotter/Components/screens/schedule/model.dart';
import 'package:spotter/Components/screens/trainer_profile/api.dart';
import 'package:spotter/Components/screens/trainer_profile/model.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/core/http.dart';
import 'package:spotter/core/storage.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:spotter/utils/retry.dart';
import 'package:spotter/utils/userDataLoad.dart';

class Schedule extends StatefulWidget {
  @override
  ComponentState createState() => ComponentState();
}

class ComponentState extends State<Schedule> {
  Future<List<ScheduleCardDetails>> response;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    response = fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(232, 44, 53, 1),
            title: Text(
              "Schedule",
            ),
            centerTitle: true,
          ),
          body: FutureBuilder(
              future: response,
              builder: (BuildContext context,
                  AsyncSnapshot<List<ScheduleCardDetails>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return LoadingIndicator();
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      print("error");
                      print(snapshot.error.toString());
                      if (snapshot.error.toString() ==
                          "Exception: Invalid session") {
                        goToLoginPage(context);
                        return Container();
                      } else {
                        return retry("Error fetching schedule!", fetchEvents);
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                          children: snapshot.data
                              .map<Widget>((schedule) =>
                                  scheduleCard(schedule, update: () {
                                    update(schedule.id);
                                  }, cancel: () {
                                    cancel(schedule.id);
                                  }, checkIn: () {
                                    Navigator.pushNamed(context, '/check_in',
                                        arguments: {"id": schedule.id});
                                  }, chatWith: () {
                                    chatWith(schedule.id);
                                  }, actions: true))
                              .toList()),
                    );
                    break;
                  default:
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(children: []),
                    );
                }
              })),
      if (loading) LoadingIndicator()
    ]);
  }

  disableLoader() {
    setState(() {
      loading = false;
    });
  }

  enableLoader() {
    setState(() {
      loading = true;
    });
  }

  chatWith(int id) async {
    ScheduleDetails details = await fetchDetails(id);
    Provider.of<AppState>(context, listen: false)
        .setCurrentRoute("/chat_details");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ChatDetails(
                details.trainWith, "", details.trainerPermalink, "trainer")));
  }

  Future<List<ScheduleCardDetails>> fetchEvents() async {
    final api = HttpClient(productionApiUrls.user);
    final SecureStorage storage = SecureStorage();
    String permalink = await storage.getPermalink();
    try {
      final result = await api.get("/appointments?user_permalink=$permalink",
          withAuthHeaders: true);

      print(result);
      return ScheduleCardDetails.parseSchedules(
          result["bookedAppointments"], "trainer");
    } catch (e) {
      print('error - $e');
      return Future.error(e.toString());
    }
  }

  Future<ScheduleDetails> fetchDetails(int id) async {
    final api = HttpClient(productionApiUrls.user);
    enableLoader();
    try {
      final result = await api.get("/appointments/$id", withAuthHeaders: true);
      print(result);
      disableLoader();
      return ScheduleDetails.fromJSON(result, "trainer");
    } catch (e) {
      print("error - $e");
      disableLoader();
    }
  }

  Future<TrainerDetails> fetchTrainerDetails(String permalink) async {
    try {
      enableLoader();

      TrainerDetails trainer = await getTrainerDetails(permalink);
      disableLoader();

      return trainer;
    } catch (e) {
      print('e - $e');
      disableLoader();
    }
  }

  update(int id) async {
    ScheduleDetails details = await fetchDetails(id);
    TrainerDetails trainer =
        await fetchTrainerDetails(details.trainerPermalink);
    await Navigator.pushNamed(context, '/update_appointment', arguments: {
      "permalink": details.trainerPermalink,
      "id": id,
      "name": details.trainWith,
      "workouts": trainer.specialization
    });
    setState(() {
      response = fetchEvents();
    });
  }

  cancel(int id) {
    popupDialog(context, "Appointment",
        "Are you sure you want to cancel the appointment?", [
      TextButton(
        child: Text("Back"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      TextButton(
        child: Text("Confirm"),
        onPressed: () {
          cancelAppointment(id);
          Navigator.of(context).pop();
        },
      )
    ]);
  }

  cancelAppointment(int id) async {
    final api = HttpClient(productionApiUrls.user);
    enableLoader();
    try {
      final result = await api.delete("/appointments/$id?reason=''",
          withAuthHeaders: true);
      print(result);
      disableLoader();
      setState(() {
        response = fetchEvents();
      });
    } catch (e) {
      print("error - $e");
      disableLoader();
    }
  }
}
