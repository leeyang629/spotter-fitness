import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spotter/Components/common/LoadingIndicator.dart';
import 'package:spotter/utils/retry.dart';
import 'package:spotter/utils/userDataLoad.dart';

class Purchases extends StatefulWidget {
  const Purchases();

  @override
  _PurchasesState createState() => _PurchasesState();
}

class _PurchasesState extends State<Purchases> {
  Future<dynamic> response;
  @override
  void initState() {
    super.initState();
    response = fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(232, 44, 53, 1),
          title: Text(
            "Purchases",
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: response,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                      return retry("Error fetching Purchases!", fetchEvents);
                    }
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                        children: snapshot.data
                            .map<Widget>((schedule) => purchaseItem())
                            .toList()),
                  );
                  break;
                default:
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(children: []),
                  );
              }
            }));
  }

  Future<dynamic> fetchEvents() async {
    // final api = HttpClient(productionApiUrls.user);
    // enableLoader();
    try {
      // final result = await api.get("/appointments/$id", withAuthHeaders: true);
      // print(result);
      // disableLoader();
      // return ScheduleDetails.fromJSON(result, "trainer");
      await Future.delayed(Duration(seconds: 1));
      return [1, 2, 3];
    } catch (e) {
      print("error - $e");
      // disableLoader();
    }
  }

  Widget purchaseItem() {
    return Container(
      child: (InkWell(
        borderRadius: BorderRadius.circular(24),
        child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 5, 25, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      child: Icon(
                    Icons.person,
                    size: 80,
                  )),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text('Test Gym',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text("2 out of 4 passes available")
                      ],
                    ),
                  )
                ],
              ),
            )),
        onTap: () {},
      )),
    );
  }
}
