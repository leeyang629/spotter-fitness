import 'package:flutter/material.dart';
import 'package:spotter/Components/common/LoadingIndicator.dart';
import 'package:spotter/Components/common/verification_code.dart';
import 'package:spotter/Components/screens/dashboard/trainer/model.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/core/http.dart';

class StartSession extends StatefulWidget {
  final int id;
  StartSession(this.id);
  @override
  ComponentState createState() => ComponentState();
}

class ComponentState extends State<StartSession> {
  Future<ScheduleDetails> response;
  bool loading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(232, 44, 53, 1),
            title: Text(
              "Start Session",
            ),
            centerTitle: true,
          ),
          body: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 182, 0, 1),
              ),
              child: Center(
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
                        Icons.keyboard_outlined,
                        color: Colors.white,
                        size: 96,
                      ),
                      Text(
                        "Enter Secret Code shared by your Trainee",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: VerficationCode(startSession)),
                    ],
                  ),
                ),
              ))),
      if (loading) LoadingIndicator()
    ]);
  }

  startSession(String code) async {
    final api = HttpClient(productionApiUrls.user);
    setState(() {
      loading = true;
    });
    try {
      final result = await api.post(
          "/start_session?id=${widget.id}&secret=$code", {},
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
