import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:spotter/Components/screens/checkout/checkout.dart';
import 'package:spotter/Components/screens/checkout/flutter_checkout.dart';
import 'package:spotter/Components/screens/checkout/server.dart';
import 'package:spotter/Components/screens/layout/LayoutWithUser.dart';
import 'package:spotter/Components/screens/trainers_list/model.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/core/http.dart';
import 'package:spotter/notification_utils/background_notifications.dart';
import 'package:spotter/notification_utils/foreground_notifications.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:spotter/utils/permissions.dart';
import 'package:spotter/utils/retry.dart';
import './list_card.dart';

class TrainersList extends StatefulWidget {
  @override
  _TrainersListState createState() => _TrainersListState();
}

class _TrainersListState extends State<TrainersList> {
  int page = 1;
  final int perPage = 20;
  bool hasMore = true;
  List<TrainerData> trainers = [];
  bool fetching = false;
  bool error = false;
  @override
  void initState() {
    super.initState();
    onReceivingLocalNotification(context);
    // Called when clicking on notification and app is in background or terminated.
    onBackgroundNotificationClick(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchTrainers());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWithUser(
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                    margin: EdgeInsets.only(top: 20, left: 20),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: Colors.black))),
                    child: Text('Available Trainers',
                        style: TextStyle(fontSize: 30, color: Colors.black))),
                // TextButton(
                //     onPressed: () async {
                //       // final sessionId = await Server().createCheckout();
                //       // final result = await Navigator.push(
                //       //     context,
                //       //     MaterialPageRoute(
                //       //         builder: (context) => CheckoutPage(
                //       //               sessionId: sessionId,
                //       //             )));
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => StripeCheckout()));
                //     },
                //     child: Text("checkout"))
              ],
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0)),
            // popularTrainers(),
            Padding(padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0)),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: RefreshIndicator(
                    onRefresh: () {
                      setState(() {
                        page = 1;
                        trainers = [];
                      });
                      return fetchTrainers();
                    },
                    child: error
                        ? retry("Error Fetching records", fetchTrainers)
                        : trainers.isEmpty
                            ? (fetching
                                ? Container()
                                : retry("No trainers found near you",
                                    fetchTrainers))
                            : ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: trainers.length,
                                itemBuilder: (context, index) {
                                  if (index == trainers.length - 5 && hasMore) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback(
                                            (_) => fetchTrainers());
                                  }
                                  final trainer = trainers[index];
                                  return Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: listCard(trainer, context));
                                }),
                  )),
            ),
          ],
        ),
      ),
      noPadding: true,
    );
  }

  Widget popularTrainers() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
            Color.fromRGBO(216, 150, 20, 1),
            Color.fromRGBO(251, 200, 78, 1),
          ])),
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Popular personal Trainers",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.filled(10, 0)
                  .map((e) => InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/trainer_profile',
                              arguments: {"permalink": ""});
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Icon(
                            Icons.account_circle_rounded,
                            size: 70,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Future fetchTrainers() async {
    if (!fetching) {
      if (mounted) {
        setState(() {
          fetching = true;
          error = false;
        });
        Provider.of<AppState>(context, listen: false).enableSpinner();
      }
      Position location = await getPermission();
      final api = HttpClient(productionApiUrls.user);
      try {
        final result = await api.get(
            "/api/v1/users/search_trainers?search_range=${Provider.of<AppState>(context, listen: false).radius * 1609}&latitude=${location.latitude}&longitude=${location.longitude}&page=$page&per_page=$perPage",
            withAuthHeaders: true);
        Provider.of<AppState>(context, listen: false).disableSpinner();
        // print(result);
        List<String> userPreferences =
            Provider.of<AppState>(context, listen: false)
                .onBoardData
                .preferredWorkouts;
        final trainersList =
            TrainerData.parseTrainers(result["trainers"], userPreferences);
        setState(() {
          hasMore = (result["total_page"] ?? 0) > page ? true : false;
          trainers.addAll(trainersList);
          page = (result["total_page"] ?? 0) > page ? page + 1 : page;
          fetching = false;
        });
      } catch (e) {
        Provider.of<AppState>(context, listen: false).disableSpinner();
        print(e);
        setState(() {
          error = true;
          fetching = false;
        });
      }
    }
  }
}
