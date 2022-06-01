import 'package:flutter/material.dart';
import 'package:spotter/Components/screens/layout/LayoutWithUser.dart';

class DiscoverActivities extends StatefulWidget {
  @override
  ComponentState createState() => ComponentState();
}

class ComponentState extends State<DiscoverActivities> {
  @override
  Widget build(BuildContext context) {
    return LayoutWithUser(
      Stack(children: [
        Container(
          padding: EdgeInsets.only(top: 30.0, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.22,
                decoration:
                    BoxDecoration(color: Color.fromRGBO(216, 150, 21, 1)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Discover Activities",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          width: 40,
                          height: 1,
                          color: Colors.black,
                        ),
                      ),
                      Text("Discover fun new activities below:",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                          ))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Popular Near You",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color.fromRGBO(216, 150, 21, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ListView(
                    children: List.filled(4, 0)
                        .map((val) => Container(
                            height: 160,
                            margin: EdgeInsets.only(top: 20),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Opacity(
                                  opacity: 0.9,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 20),
                                    width: 240,
                                    color: Colors.black87,
                                    child: InkWell(
                                      onTap: () {},
                                      splashColor: Colors.grey,
                                      child: Stack(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Yoga",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24),
                                                ),
                                                Text("Moderate Intensity",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Opacity(
                                  opacity: 0.9,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 20),
                                    width: 240,
                                    color: Colors.black87,
                                    child: InkWell(
                                      onTap: () {},
                                      splashColor: Colors.grey,
                                      child: Stack(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Yoga",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24),
                                                ),
                                                Text("Moderate Intensity",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Opacity(
                                  opacity: 0.9,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 20),
                                    width: 240,
                                    color: Colors.black87,
                                    child: InkWell(
                                      onTap: () {},
                                      splashColor: Colors.grey,
                                      child: Stack(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Yoga",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24),
                                                ),
                                                Text("Moderate Intensity",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )))
                        .toList(),
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width * 0.125,
          top: MediaQuery.of(context).size.height * 0.22,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 14,
                        offset: Offset(0, 10))
                  ]),
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Activities",
                    contentPadding: EdgeInsets.all(12),
                    suffixIcon: Container(
                      color: Colors.black,
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    )),
              ),
            ),
          ),
        )
      ]),
      noPadding: true,
    );
  }
}
