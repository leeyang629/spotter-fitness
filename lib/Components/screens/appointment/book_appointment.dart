import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pubnub/pubnub.dart';
import 'package:spotter/Components/common/LoadingIndicator.dart';
import 'package:spotter/Components/screens/appointment/utils.dart';
import 'package:spotter/Components/screens/dashboard/trainer/model.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/core/http.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:spotter/utils/chat_subscription.dart';
import 'package:spotter/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class BookAppointment extends StatefulWidget {
  final String permalink;
  final String name;
  final String action;
  final int appointmentId;
  final List<String> workouts;
  BookAppointment(this.permalink,
      {this.name, this.action = "new", this.appointmentId, this.workouts});
  @override
  ComponentState createState() => ComponentState();
}

class ComponentState extends State<BookAppointment> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  String time;
  String startHr;
  String startMin;
  String amOrPm;
  String durationHr;
  String durationMin;
  bool enableSubmit = false;
  bool agreed = false;
  String workout;
  PubNub pubnub;

  @override
  void initState() {
    super.initState();
    if (widget.action == "update") {
      fetchDetails(widget.appointmentId);
    }
    pubnub = initiatePubNub(
        Provider.of<AppState>(context, listen: false).userPermalink);
  }

  checkConfirmBooking() {
    if (_selectedDay != null &&
        time != null &&
        startHr != null &&
        startMin != null &&
        amOrPm != null &&
        durationHr != null &&
        durationMin != null &&
        workout != null &&
        agreed) {
      setState(() {
        enableSubmit = true;
      });
    } else {
      setState(() {
        enableSubmit = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(232, 44, 53, 1),
        title: Text(
          "Book Training Session",
        ),
        centerTitle: true,
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 40),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: calendar(),
                ),
                Row(
                  children: [
                    Text("Workout type: "),
                    Expanded(
                      child: workoutType(widget.workouts ?? [], workout,
                          (String value) {
                        setState(() {
                          workout = value;
                        });
                        checkConfirmBooking();
                      }),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text("Start Time: "),
                    Container(
                      width: 60,
                      child: startTime(time, (String value) {
                        calculate24HrTime(value);
                        checkConfirmBooking();
                      }),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 60,
                      child: meridian(amOrPm, (String value) {
                        calculate24HrTimeForMeridian(value);
                      }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("Duration: "),
                    Container(
                      width: 45,
                      child: hours(durationHr, (String value) {
                        setState(() {
                          durationHr = value;
                        });
                        checkConfirmBooking();
                      }),
                    ),
                    Text(" hr"),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 45,
                      child: minutes(durationMin, (String value) {
                        setState(() {
                          durationMin = value;
                        });
                        checkConfirmBooking();
                      }),
                    ),
                    Text(" min "),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(216, 216, 216, 1))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(216, 216, 216, 1))),
                        filled: true,
                        hintText: "Additional Notes",
                        fillColor: Color.fromRGBO(216, 216, 216, 1)),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: CheckboxListTile(
                        value: agreed,
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                            "I consent to the terms and condition of the Trainer.",
                            style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(176, 182, 186, 1))),
                        onChanged: (newValue) {
                          setState(() {
                            agreed = newValue;
                          });
                          checkConfirmBooking();
                        },
                        controlAffinity: ListTileControlAffinity.leading)),
                Flex(direction: Axis.horizontal, children: [
                  Flexible(
                      fit: FlexFit.tight,
                      child: bookNow("Confirm Booking", () {
                        widget.action == "update"
                            ? updateAppointment()
                            : bookAppointment();
                      }))
                ])
              ],
            ),
          ),
        ),
        Provider.of<AppState>(context).spinner
            ? LoadingIndicator()
            : Container()
      ]),
    );
  }

  Future bookAppointment() async {
    final api = HttpClient(productionApiUrls.user);
    try {
      Provider.of<AppState>(context, listen: false).enableSpinner();
      final result = await api.post(
          "/appointments",
          {
            "appointment": {
              "trainer_permalink": widget.permalink,
              "appointment_time": {
                "date": _selectedDay.toString().substring(0, 10),
                "hour": startHr,
                "min": startMin
              },
              "duration": {"hour": durationHr, "min": durationMin},
              "other_informations": {"workout_type": workout}
            }
          },
          withAuthHeaders: true);
      Provider.of<AppState>(context, listen: false).disableSpinner();
      print(result);
      if (isNotEmpty(result["id"])) {
        pubnub.publish(
          "${widget.permalink}-dummy",
          {
            "pn_gcm": {
              "notification": {
                "title":
                    "New Appointment scheduled by ${Provider.of<AppState>(context, listen: false).userName}",
                "body": "Tap to view details",
              },
              "data": {
                "scheduleId": result["id"],
                "topic": "spotter-appointment-new",
              }
            },
          },
        );
        Navigator.pushReplacementNamed(context, '/appointment_booked',
            arguments: {"name": widget.name});
      }
    } catch (e) {
      print("error - $e");
      Provider.of<AppState>(context, listen: false).disableSpinner();
    }
  }

  Future updateAppointment() async {
    final api = HttpClient(productionApiUrls.user);
    try {
      Provider.of<AppState>(context, listen: false).enableSpinner();
      final result = await api.patch(
          "/appointments/${widget.appointmentId}",
          {
            "appointment": {
              "trainer_permalink": widget.permalink,
              "appointment_time": {
                "date": _selectedDay.toString().substring(0, 10),
                "hour": startHr,
                "min": startMin
              },
              "duration": {"hour": durationHr, "min": durationMin},
              "other_informations": {"workout_type": workout}
            }
          },
          withAuthHeaders: true);
      Provider.of<AppState>(context, listen: false).disableSpinner();
      print(result);
      Navigator.pushReplacementNamed(context, '/appointment_booked',
          arguments: {"name": widget.name});
    } catch (e) {
      print("error - $e");
      Provider.of<AppState>(context, listen: false).disableSpinner();
    }
  }

  Widget calendar() => TableCalendar(
        firstDay: DateTime.now().subtract(Duration(days: 60)),
        lastDay: DateTime.now().add(Duration(days: 60)),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        availableCalendarFormats: {
          CalendarFormat.month: 'Month',
        },
        selectedDayPredicate: (day) {
          // Use `selectedDayPredicate` to determine which day is currently selected.
          // If this returns true, then `day` will be marked as selected.

          // Using `isSameDay` is recommended to disregard
          // the time-part of compared DateTime objects.
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            // Call `setState()` when updating the selected day
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            checkConfirmBooking();
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            // Call `setState()` when updating calendar format
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          _focusedDay = focusedDay;
        },
      );

  Widget bookNow(String text, Function clickHandler) => ElevatedButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(16)),
          backgroundColor: MaterialStateProperty.all<Color>(
              enableSubmit ? Color.fromRGBO(216, 150, 21, 1) : Colors.grey),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ))),
      onPressed: enableSubmit ? clickHandler : null,
      child: Text(text, style: TextStyle(fontSize: 14, color: Colors.white)));

  calculate24HrTime(String value) {
    if (amOrPm != null && amOrPm == "PM") {
      setState(() {
        time = value;
        startHr = (int.parse(value.split(":")[0]) + 12).toString();
        startMin = value.split(":")[1];
      });
    } else {
      setState(() {
        time = value;
        startHr = value.split(":")[0];
        startMin = value.split(":")[1];
      });
    }
  }

  calculate24HrTimeForMeridian(String value) {
    if (startHr != null) {
      if (value == "PM" && (int.parse(startHr) + 12) < 24) {
        setState(() {
          startHr = (int.parse(startHr) + 12).toString();
        });
      } else if (value == "AM" && (int.parse(startHr) - 12 >= 0)) {
        setState(() {
          startHr = (int.parse(startHr) - 12).toString();
        });
      }
      setState(() {
        amOrPm = value;
      });
    }
    checkConfirmBooking();
  }

  fetchDetails(int id) async {
    final api = HttpClient(productionApiUrls.user);
    Provider.of<AppState>(context, listen: false).enableSpinner();
    try {
      final result = await api.get("/appointments/$id", withAuthHeaders: true);
      print(result);
      ScheduleDetails details = ScheduleDetails.fromJSON(result, "trainer");
      final dateVal = details.startTime.split('T')[0];
      final year = int.parse(dateVal.substring(0, 4));
      final month = int.parse(dateVal.substring(5, 7));
      final day = int.parse(dateVal.substring(8));
      final timeVal = details.startTime.split('T')[1];
      final hour = timeVal.split(':')[0];
      final mins = timeVal.split(':')[1];
      setState(() {
        _selectedDay = DateTime(year, month, day);
        time = '${int.parse(hour) % 12}:$mins';
        startHr = hour;
        startMin = mins;
        amOrPm = int.parse(hour) < 12 ? 'AM' : 'PM';
        agreed = true;
        durationHr = details.durationHr;
        durationMin = details.durationMin;
        if (widget.workouts.indexOf(details.workout) > -1) {
          workout = details.workout;
        }
      });
      Provider.of<AppState>(context, listen: false).disableSpinner();
    } catch (e) {
      print("error - $e");
      Provider.of<AppState>(context, listen: false).disableSpinner();
    }
  }
}
