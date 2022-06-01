import 'package:flutter/material.dart';
import 'package:spotter/Components/common/LoadingIndicator.dart';
import 'package:spotter/Components/screens/dashboard/trainer/api.dart';
import 'package:spotter/Components/screens/dashboard/trainer/model.dart';
import 'package:spotter/utils/dateTimeUtils.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/core/http.dart';
import 'package:spotter/utils/retry.dart';
import 'package:spotter/utils/userDataLoad.dart';

class ScheduleDetail extends StatefulWidget {
  final int id;
  ScheduleDetail(this.id);
  @override
  ComponentState createState() => ComponentState();
}

class ComponentState extends State<ScheduleDetail> {
  Future<ScheduleDetails> response;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    response = fetchDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(232, 44, 53, 1),
            title: Text(
              "Schedule Details",
            ),
            centerTitle: true,
          ),
          body: FutureBuilder(
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
                        return retry("Error fetching schedule!", () {
                          setState(() {
                            response = fetchDetails(widget.id);
                          });
                        });
                      }
                    }
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromRGBO(15, 32, 84, 1),
                        ),
                        padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
                        width: MediaQuery.of(context).size.width - 80,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Appointment Booking Request",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("from ${snapshot.data.trainWith}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "@ ${formatDateDDMMMYYYY(DateTime.parse(snapshot.data.startTime.split('T')[0]))} for ${snapshot.data.durationHr} hr ${snapshot.data.durationMin} min",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 16.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  button("Deny", cancelAppointment),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  button("Confirm", confirmAppointment)
                                ],
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
              })),
      if (loading) LoadingIndicator()
    ]);
  }

  confirmAppointment() async {
    final api = HttpClient(productionApiUrls.user);
    setState(() {
      loading = true;
    });
    try {
      final result = await api.post("/approve_appointment?id=${widget.id}", {},
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
