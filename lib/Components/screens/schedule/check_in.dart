import 'package:flutter/material.dart';
import 'package:spotter/Components/common/LoadingIndicator.dart';
import 'package:spotter/Components/screens/dashboard/trainer/model.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/core/http.dart';
import 'package:spotter/utils/retry.dart';
import 'package:spotter/utils/userDataLoad.dart';

class CheckIn extends StatefulWidget {
  final int id;
  CheckIn(this.id);
  @override
  ComponentState createState() => ComponentState();
}

class ComponentState extends State<CheckIn> {
  Future<ScheduleDetails> response;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    response = fetchDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(232, 44, 53, 1),
            title: Text(
              "Check-In",
            ),
            centerTitle: true,
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 182, 0, 1),
            ),
            child: FutureBuilder(
                future: response,
                builder: (BuildContext context,
                    AsyncSnapshot<ScheduleDetails> snapshot) {
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
                          return retry(
                              "Error fetching schedule!", fetchDetails);
                        }
                      }
                      final details = snapshot.data;
                      return Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromRGBO(232, 44, 53, 1),
                          ),
                          padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
                          width: MediaQuery.of(context).size.width - 80,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_sharp,
                                color: Colors.white,
                                size: 96,
                              ),
                              Text(
                                "Training Session Today!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "Your ${details.startHr} ${details.startMeridian} session with \n ${snapshot.data.trainWith} is coming up",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  details.secretCode,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 30),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16.0,
                                ),
                                child: Text(
                                  "Share this code with your trainer to start the session",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                      break;
                    default:
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(children: []),
                      );
                  }
                }),
          )),
      if (loading) LoadingIndicator()
    ]);
  }

  Future<ScheduleDetails> fetchDetails() async {
    final api = HttpClient(productionApiUrls.user);
    try {
      final result =
          await api.get("/appointments/${widget.id}", withAuthHeaders: true);

      print(result);
      return ScheduleDetails.fromJSON(result, "user");
    } catch (e) {
      print("error - $e");
      return Future.error(e.toString());
    }
  }

  confirmAppointment() async {
    final api = HttpClient(productionApiUrls.user);
    setState(() {
      loading = true;
    });
    try {
      final result = await api.post("/start_session?id=${widget.id}", {},
          withAuthHeaders: true);
      print(result);
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
    } catch (e) {
      print("error - $e");
      setState(() {
        loading = false;
      });
    }
  }

  cancelAppointment() async {
    final api = HttpClient(productionApiUrls.user);
    setState(() {
      loading = true;
    });
    try {
      final result = await api.delete("/appointments/${widget.id}?reason=''",
          withAuthHeaders: true);
      print(result);
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
    } catch (e) {
      print("error - $e");
      setState(() {
        loading = false;
      });
    }
  }

  Widget button(String text, Function handler) {
    return InkWell(
      onTap: handler,
      child: Container(
        padding: EdgeInsets.fromLTRB(40, 12, 40, 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 2)),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
