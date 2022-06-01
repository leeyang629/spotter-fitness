import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:spotter/Components/common/LoadingIndicator.dart';
import 'package:spotter/Components/common/dialog.dart';
import 'package:spotter/Components/common/profilePic.dart';
import 'package:spotter/Components/common/scheduleCard.dart';
import 'package:spotter/Components/screens/chat/chat_details.dart';
import 'package:spotter/Components/screens/dashboard/dashboardCard.dart';
import 'package:spotter/Components/screens/dashboard/trainer/api.dart';
import 'package:spotter/Components/screens/dashboard/trainer/trainer_schedule.dart';
import 'package:spotter/Components/screens/layout/MenuSliderWrapper.dart';
import 'package:spotter/notification_utils/background_notifications.dart';
import 'package:spotter/notification_utils/foreground_notifications.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:spotter/utils/chat_subscription.dart';

class TrainerDashboard extends StatefulWidget {
  @override
  ComponentState createState() => ComponentState();
}

class ComponentState extends State<TrainerDashboard>
    with TickerProviderStateMixin {
  String menuState = 'close';
  String timeSpan = "Month";
  int totalSessions = 0;
  int totalFollowers = 0;
  int viewCount = 0;
  bool metricsLoading = false;
  AnimationController openMenuController;
  @override
  void initState() {
    super.initState();
    openMenuController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));

    /// Called when notification sent while app is in open/active state.
    onReceivingLocalNotification(context);
    // /// Called when clicking on notification and app is in background or terminated.
    onBackgroundNotificationClick(context);

    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance
          .addPostFrameCallback((_) => loadMetrics('Month'));
    }
  }

  loadMetrics(String timeSpan) async {
    // closeOverlay();
    setState(() {
      metricsLoading = true;
    });
    final result = await fetchTrainerMetrics(context, timeSpan);
    int sessionCount = result["appointment"].map((value) {
      if (value["status"] != "cancelled") return value["totalCount"];
      return 0;
    }).reduce((acc, element) {
      return acc + element;
    });
    setState(() {
      viewCount = result["views"]["totalCount"];
      totalFollowers = result["followers"]["totalCount"];
      totalSessions = sessionCount;
      metricsLoading = false;
    });
  }

  updateMenuState(String value) {
    setState(() {
      menuState = value;
    });
    if (value == 'open') {
      openMenuController?.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 246, 1),
      body: SafeArea(
        child: Stack(children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          "Hello ${Provider.of<AppState>(context, listen: false).userName},",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/chat');
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
                              child: Stack(children: [
                                Icon(
                                  Icons.question_answer_outlined,
                                  size: 30,
                                  // color: Colors.white30,
                                ),
                                if (Provider.of<AppState>(context).newMessage)
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.red),
                                        height: 8,
                                        width: 8,
                                      ))
                              ]),
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                updateMenuState("open");
                              },
                              child: ProfilePic(40,
                                  color: Colors.black,
                                  imageUrl:
                                      Provider.of<AppState>(context).userImgUrl,
                                  cache: true)),
                        ],
                      )
                    ],
                  ),
                  Text(
                    "Your Dashboard",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: [
                          Text("For the past:"),
                          SizedBox(
                            width: 10,
                          ),
                          Wrap(
                              spacing: 5,
                              runSpacing: 0,
                              // direction: Axis.horizontal,
                              children: ["Month", "15Days", "Day"].map((value) {
                                return TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .all<Color>(timeSpan == value
                                            ? Color.fromRGBO(247, 165, 4, 1)
                                            : Color.fromRGBO(234, 234, 235, 1)),
                                  ),
                                  child: Text(value,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              Color.fromRGBO(54, 53, 52, 1))),
                                  onPressed: () {
                                    setState(() {
                                      timeSpan = value;
                                    });
                                    loadMetrics(value);
                                  },
                                );
                              }).toList())
                        ],
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            dashboardCard(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 40,
                                child: metricsLoading
                                    ? LoadingIndicator()
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(Icons.check_circle),
                                              // Icon(Icons.more_horiz)
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                totalFollowers.toString(),
                                                style: TextStyle(
                                                  fontSize: 24,
                                                ),
                                              ),
                                              Text("Total Followers")
                                            ],
                                          )
                                        ],
                                      )),
                            dashboardCard(
                              color: Color.fromRGBO(216, 150, 20, 1),
                              width: MediaQuery.of(context).size.width / 2 - 40,
                              child: metricsLoading
                                  ? LoadingIndicator()
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.group,
                                              color: Colors.white,
                                            ),
                                            // Icon(
                                            //   Icons.more_horiz,
                                            //   color: Colors.white,
                                            // )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              totalSessions.toString(),
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.white),
                                            ),
                                            Text("Training sessions",
                                                style: TextStyle(
                                                    color: Colors.white))
                                          ],
                                        )
                                      ],
                                    ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            // dashboardCard(
                            //   padding: 0,
                            //   height: 220,
                            //   width: MediaQuery.of(context).size.width / 2 - 40,
                            //   gradient: LinearGradient(
                            //       colors: [
                            //         Color.fromRGBO(252, 196, 15, 1),
                            //         Color.fromRGBO(254, 177, 4, 1),
                            //         Color.fromRGBO(255, 169, 0, 1)
                            //       ],
                            //       end: Alignment.bottomCenter,
                            //       begin: Alignment.topCenter),
                            //   child: Column(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Padding(
                            //         padding: const EdgeInsets.all(12.0),
                            //         child: Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.spaceBetween,
                            //           children: [
                            //             Icon(
                            //               Icons.add_circle,
                            //               color: Colors.white,
                            //             ),
                            //             Icon(
                            //               Icons.more_horiz,
                            //               color: Colors.white,
                            //             )
                            //           ],
                            //         ),
                            //       ),
                            //       Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.start,
                            //         children: [
                            //           Padding(
                            //             padding:
                            //                 const EdgeInsets.only(left: 12.0),
                            //             child: Text(
                            //               "-",
                            //               style: TextStyle(
                            //                 color: Colors.white,
                            //                 fontSize: 24,
                            //               ),
                            //             ),
                            //           ),
                            //           Padding(
                            //             padding:
                            //                 const EdgeInsets.only(left: 12.0),
                            //             child: Text("New sign-ups",
                            //                 style:
                            //                     TextStyle(color: Colors.white)),
                            //           ),
                            //           SizedBox(
                            //             width:
                            //                 MediaQuery.of(context).size.width /
                            //                         2 -
                            //                     40,
                            //             height: 100,
                            //             child: ClipRRect(
                            //               borderRadius: BorderRadius.only(
                            //                   bottomLeft: Radius.circular(20),
                            //                   bottomRight: Radius.circular(20)),
                            //               child: LineChart(LineChartData(
                            //                 borderData:
                            //                     FlBorderData(show: false),
                            //                 gridData: FlGridData(show: false),
                            //                 titlesData:
                            //                     FlTitlesData(show: false),
                            //                 minX: 0,
                            //                 minY: 0,
                            //                 maxY: 12,
                            //                 lineTouchData:
                            //                     LineTouchData(enabled: false),
                            //                 lineBarsData: [
                            //                   LineChartBarData(
                            //                       colors: [Colors.white],
                            //                       barWidth: 1,
                            //                       spots: [
                            //                         FlSpot(0, 8),
                            //                         FlSpot(1, 8),
                            //                       ],
                            //                       isCurved: true,
                            //                       dotData: FlDotData(
                            //                         show: false,
                            //                       ),
                            //                       belowBarData: BarAreaData(
                            //                           gradientFrom:
                            //                               Offset(0, -1.0),
                            //                           gradientTo:
                            //                               Offset(0, 1.0),
                            //                           show: true,
                            //                           colors: [
                            //                             Color.fromRGBO(
                            //                                 179, 122, 11, 1),
                            //                             Color.fromRGBO(
                            //                                 216, 150, 21, 1)
                            //                           ]))
                            //                 ],
                            //               )),
                            //             ),
                            //           )
                            //         ],
                            //       )
                            //     ],
                            //   ),
                            // ),
                            dashboardCard(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 40,
                                child: metricsLoading
                                    ? LoadingIndicator()
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(Icons.visibility),
                                              // Icon(Icons.more_horiz)
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                viewCount.toString(),
                                                style: TextStyle(
                                                  fontSize: 24,
                                                ),
                                              ),
                                              Text("Total Profile Views")
                                            ],
                                          )
                                        ],
                                      ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  TrainerSchedule()
                ],
              ),
            ),
          ),
          if (menuState == 'open')
            GestureDetector(
                onTapDown: (TapDownDetails details) {
                  updateMenuState('close');
                  openMenuController?.reverse();
                },
                child: Opacity(
                    opacity: 0.5,
                    child: Container(
                      color: Colors.black,
                    ))),
          MenuSliderWrapper(
              menuState: menuState,
              updateMenuState: updateMenuState,
              openMenuController: openMenuController),
          Provider.of<AppState>(context).spinner
              ? LoadingIndicator()
              : Container()
        ]),
      ),
    );
  }
}
