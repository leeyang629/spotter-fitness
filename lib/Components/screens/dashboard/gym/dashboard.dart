import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:spotter/Components/common/LoadingIndicator.dart';
import 'package:spotter/Components/common/profilePic.dart';
import 'package:spotter/Components/screens/dashboard/dashboardCard.dart';
import 'package:spotter/Components/screens/dashboard/gym/api.dart';
import 'package:spotter/Components/screens/dashboard/gym/overlay.dart';
import 'package:spotter/Components/screens/layout/MenuSliderWrapper.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:spotter/utils/utils.dart';

class GymDashboard extends StatefulWidget {
  @override
  ComponentState createState() => ComponentState();
}

class ComponentState extends State<GymDashboard> with TickerProviderStateMixin {
  String menuState = 'close';
  AnimationController openMenuController;
  OverlayEntry _overlayEntry;
  bool viewLoading = false;
  int viewCount = 0;
  String timeSpan = "Month";
  @override
  void initState() {
    super.initState();
    openMenuController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance
          .addPostFrameCallback((_) => loadMetrics('Month'));
    }
  }

  loadMetrics(String timeSpan) async {
    closeOverlay();
    setState(() {
      viewLoading = true;
    });
    final result = await fetchGymMetrics(context, timeSpan);
    if (isNotEmpty(result)) {
      setState(() {
        viewCount = result["views"]["totalCount"];
      });
    }
    setState(() {
      viewLoading = false;
    });
    print(result);
  }

  closeOverlay() {
    if (this._overlayEntry != null) {
      this._overlayEntry?.remove();
      this._overlayEntry = null;
    }
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
          GestureDetector(
            onTap: () {
              closeOverlay();
            },
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hello ${Provider.of<AppState>(context, listen: false).userName},",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                        InkWell(
                            onTap: () {
                              updateMenuState("open");
                            },
                            child: ProfilePic(
                              40,
                              color: Colors.black,
                              imageUrl:
                                  Provider.of<AppState>(context, listen: false)
                                      .userImgUrl,
                              cache: true,
                            )),
                      ],
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
                                children:
                                    ["Month", "15Days", "Day"].map((value) {
                                  return TextButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .all<Color>(timeSpan == value
                                              ? Color.fromRGBO(247, 165, 4, 1)
                                              : Color.fromRGBO(
                                                  234, 234, 235, 1)),
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
                                  width: MediaQuery.of(context).size.width / 2 -
                                      40,
                                  child: viewLoading
                                      ? LoadingIndicator()
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                        )),
                              // dashboardCard(
                              //   color: Color.fromRGBO(216, 150, 20, 1),
                              //   width:
                              //       MediaQuery.of(context).size.width / 2 - 40,
                              //   child: Column(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       Row(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.spaceBetween,
                              //         children: [
                              //           Icon(
                              //             Icons.group,
                              //             color: Colors.white,
                              //           ),
                              //           Icon(
                              //             Icons.more_horiz,
                              //             color: Colors.white,
                              //           )
                              //         ],
                              //       ),
                              //       Column(
                              //         children: [
                              //           Text(
                              //             "0",
                              //             style: TextStyle(
                              //                 fontSize: 24,
                              //                 color: Colors.white),
                              //           ),
                              //           Text("Trainers",
                              //               style:
                              //                   TextStyle(color: Colors.white))
                              //         ],
                              //       )
                              //     ],
                              //   ),
                              // ),
                              // dashboardCard(
                              //   width:
                              //       MediaQuery.of(context).size.width / 2 - 40,
                              // )
                            ],
                          ),
                          Column(
                            children: [
                              // dashboardCard(
                              //   padding: 0,
                              //   height: 220,
                              //   width:
                              //       MediaQuery.of(context).size.width / 2 - 40,
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
                              //               "0",
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
                              //                 style: TextStyle(
                              //                     color: Colors.white)),
                              //           ),
                              //           SizedBox(
                              //             width: MediaQuery.of(context)
                              //                         .size
                              //                         .width /
                              //                     2 -
                              //                 40,
                              //             height: 100,
                              //             child: ClipRRect(
                              //               borderRadius: BorderRadius.only(
                              //                   bottomLeft: Radius.circular(20),
                              //                   bottomRight:
                              //                       Radius.circular(20)),
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
                              // dashboardCard(
                              //   width:
                              //       MediaQuery.of(context).size.width / 2 - 40,
                              // )
                            ],
                          ),
                        ],
                      ),
                    ),
                    // dashboardCard(
                    //     width: MediaQuery.of(context).size.width - 40,
                    //     color: Color.fromRGBO(112, 116, 119, 1),
                    //     height: 120,
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           "Spotter Revenue",
                    //           style: TextStyle(
                    //             color: Colors.white,
                    //             fontSize: 24,
                    //           ),
                    //         ),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Padding(
                    //               padding: const EdgeInsets.only(top: 12.0),
                    //               child: Column(
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                 children: [
                    //                   Text("\$ -",
                    //                       style:
                    //                           TextStyle(color: Colors.white)),
                    //                   Text("06 February 2022",
                    //                       style: TextStyle(
                    //                           color: Colors.white,
                    //                           fontSize: 12)),
                    //                 ],
                    //               ),
                    //             ),
                    //             SizedBox(
                    //               height: 60,
                    //               width:
                    //                   MediaQuery.of(context).size.width * 0.4,
                    //               child: LineChart(LineChartData(
                    //                 borderData: FlBorderData(show: false),
                    //                 gridData: FlGridData(show: false),
                    //                 titlesData: FlTitlesData(show: false),
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
                    //                       belowBarData:
                    //                           BarAreaData(show: false))
                    //                 ],
                    //               )),
                    //             )
                    //           ],
                    //         )
                    //       ],
                    //     )),
                  ],
                ),
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
