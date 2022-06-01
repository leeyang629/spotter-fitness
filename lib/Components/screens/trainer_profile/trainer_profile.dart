import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:spotter/Components/common/IconWithText.dart';
import 'package:spotter/Components/common/LoadingIndicator.dart';
import 'package:spotter/Components/common/buttons.dart';
import 'package:spotter/Components/common/dialog.dart';
import 'package:spotter/Components/common/profilePic.dart';
import 'package:spotter/Components/common/slide_container.dart';
import 'package:spotter/Components/screens/chat/chat_details.dart';
import 'package:spotter/Components/screens/layout/Layout.dart';
import 'package:spotter/Components/screens/profile_setup/common/capture_image.dart';
import 'package:spotter/Components/screens/trainer_profile/model.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:spotter/utils/debounce.dart';
import 'package:spotter/utils/upload_image.dart';
import 'package:spotter/utils/userDataLoad.dart';
import 'package:spotter/utils/utils.dart';

import './api.dart';

class TrainerProfile extends StatefulWidget {
  final String permalink;
  final bool update;
  TrainerProfile(this.permalink, {this.update = false});
  @override
  _TrainerProfileState createState() => _TrainerProfileState();
}

class _TrainerProfileState extends State<TrainerProfile> {
  Future<TrainerDetails> response;
  bool following = false;
  Timer deboundTimer;
  File _image;
  bool editImage = false;
  @override
  void initState() {
    super.initState();
    response = getTrainerDetails(widget.permalink);
    initiateValues(response);
  }

  initiateValues(Future<TrainerDetails> response) async {
    final result = await response;
    setState(() {
      following = result.userIsFollowing;
    });
  }

  updateImageFile(File updatedImageFile) {
    setState(() {
      _image = updatedImageFile;
    });
  }

  updateFollowing(bool value) {
    setState(() {
      following = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: response,
        builder:
            (BuildContext context, AsyncSnapshot<TrainerDetails> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                  color: Color.fromRGBO(245, 245, 246, 1),
                  child: LoadingIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                print("error");
                print(snapshot.error.toString());
                if (snapshot.error.toString() == "Exception: Invalid session") {
                  goToLoginPage(context);
                  return Container();
                } else {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => errorDialog(context, () {
                            setState(() {
                              response = getTrainerDetails(widget.permalink);
                            });
                            Navigator.pop(context);
                          }, "Error fetching trainer data"));
                  return Container();
                }
              }
              return trainerDetails(snapshot.data);
            default:
              if (snapshot.hasError) {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => errorDialog(context, () {
                          setState(() {});
                          Navigator.pop(context);
                        }, "Error fetching user data"));
                return Container();
              } else {
                return trainerDetails(snapshot.data);
              }
          }
        });
  }

  Widget trainerDetails(TrainerDetails details) => Layout(
        Stack(
          children: [
            SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                            color: Color.fromRGBO(216, 216, 216, 1),
                            padding: EdgeInsets.only(left: 8, top: 8),
                            height: MediaQuery.of(context).size.height * 0.2,
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                backButton(() => Navigator.pop(context)),
                                if (widget.update)
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context,
                                            '/update_trainer_profile_setup');
                                      },
                                      child: Text('Edit'))
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          flex: 6,
                                          fit: FlexFit.tight,
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            margin: EdgeInsets.only(right: 10),
                                            child: Text(details.name,
                                                style: TextStyle(
                                                    // color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          fit: FlexFit.tight,
                                          child: iconWithFlexibleText(
                                              Icons.location_on, details.city),
                                        )
                                      ]),
                                  // Text('Specialisation in Fitness',
                                  //     style: TextStyle(
                                  //       // color: Colors.white,
                                  //       fontSize: 14,
                                  //     )),
                                  if (!widget.update)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: _follow(
                                              following
                                                  ? "Following"
                                                  : 'Follow', () {
                                            if (following) {
                                              updateFollowing(false);
                                              deboundTimer = debounce(
                                                  1000, deboundTimer, () {
                                                unFollowApi(widget.permalink,
                                                    updateFollowing);
                                              });
                                            } else {
                                              updateFollowing(true);
                                              deboundTimer = debounce(
                                                  1000, deboundTimer, () {
                                                followApi(widget.permalink,
                                                    updateFollowing);
                                              });
                                            }
                                          }, enable: !following),
                                          margin: EdgeInsets.only(right: 10),
                                        ),
                                        _follow('Message', () {
                                          Provider.of<AppState>(context,
                                                  listen: false)
                                              .setCurrentRoute("/chat_details");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      ChatDetails(
                                                          details.name,
                                                          "${Provider.of<AppState>(context, listen: false).userPermalink}_${widget.permalink}",
                                                          widget.permalink,
                                                          "trainer")));
                                        }, enable: true)
                                      ],
                                    ),
                                  if (!widget.update)
                                    Flex(direction: Axis.horizontal, children: [
                                      Flexible(
                                          fit: FlexFit.tight,
                                          child: _follow("Book Now", () {
                                            Navigator.pushNamed(
                                                context, "/book_appointment",
                                                arguments: {
                                                  "permalink": widget.permalink,
                                                  "name": details.name,
                                                  "workouts":
                                                      details.specialization
                                                });
                                          }, enable: true))
                                    ]),
                                  // Row(
                                  //   children: [
                                  //     Icon(Icons.location_on, size: 18),
                                  //     Text('Vizag', style: TextStyle(fontSize: 12.0))
                                  //   ],
                                  // )
                                ],
                              ),
                              Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _engagementCard(
                                            details.rating, 'Ratings'),
                                        Container(
                                          height: 30.0,
                                          width: 1.0,
                                          color:
                                              Color.fromRGBO(148, 165, 166, 1),
                                        ),
                                        _engagementCard(
                                            details.following, 'Following'),
                                        Container(
                                          height: 30.0,
                                          width: 1.0,
                                          color:
                                              Color.fromRGBO(148, 165, 166, 1),
                                        ),
                                        _engagementCard(
                                            details.followers, 'Followers'),
                                      ])),
                              Container(
                                height: 1.0,
                                color: Color.fromRGBO(229, 229, 229, 1),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  sociaMediaIcons(
                                      "assets/images/facebook-logo.svg", () {
                                    launchUrl(details.facebook);
                                  }, details.facebook, width: 12),
                                  sociaMediaIcons(
                                      "assets/images/twitter-logo.svg", () {
                                    launchUrl(isNotEmpty(details.twitter)
                                        ? "https://twitter.com/${details.twitter}"
                                        : details.twitter);
                                  }, details.twitter),
                                  sociaMediaIcons(
                                      "assets/images/instagram-logo.svg", () {
                                    launchUrl(isNotEmpty(details.instagram)
                                        ? "https://www.instagram.com/${details.instagram}"
                                        : details.instagram);
                                  }, details.instagram),
                                  sociaMediaIcons(
                                      "assets/images/youtube-logo.svg", () {
                                    launchUrl(details.youtube);
                                  }, details.youtube),
                                ],
                              ),
                              details.showPrice
                                  ? _achievementCard(
                                      "Price",
                                      "${details.price}/hr",
                                      Color.fromRGBO(255, 169, 0, 1))
                                  : null,
                              _achievementCard(
                                  'Certifications',
                                  details.certifications,
                                  Color.fromRGBO(232, 44, 53, 1)),
                              _achievementCard(
                                  'Published Articles',
                                  details.publications,
                                  Color.fromRGBO(15, 32, 84, 1)),
                              _achievementCard(
                                  'Conferences and Expose attended',
                                  details.conferences,
                                  Color.fromRGBO(252, 196, 15, 1)),
                              if (details.specialization.length > 0)
                                ...specialization(details)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: MediaQuery.of(context).size.width * 0.5 - 65,
                    top: MediaQuery.of(context).size.height * 0.2 - 65,
                    child: GestureDetector(
                      onTap: () {
                        if (widget.update) {
                          setState(() {
                            editImage = true;
                          });
                        }
                      },
                      child: ProfilePic(
                        130,
                        color: Colors.black,
                        imageUrl: details.imageURL,
                        showEditIcon: widget.update,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (editImage)
              SliderContainer(
                  open: editImage,
                  close: () async {
                    setState(() {
                      editImage = false;
                    });
                    if (_image != null) {
                      await uploadImage(context, _image);
                      setState(() {
                        _image = null;
                        response = getTrainerDetails(widget.permalink);
                      });
                    }
                  },
                  child: Container(
                      alignment: Alignment.center,
                      child: CaptureImage(_image, updateImageFile, null, null)))
          ],
        ),
        noPadding: true,
        headerVisible: false,
        bottomSafe: false,
      );

  Widget _follow(String text, Function clickHandler, {bool enable = false}) =>
      ElevatedButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.fromLTRB(16, 2, 16, 2)),
              backgroundColor: MaterialStateProperty.all<Color>(
                  enable ? Color.fromRGBO(216, 150, 21, 1) : Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                side: BorderSide(
                    color: enable ? Colors.transparent : Colors.black),
                borderRadius: BorderRadius.circular(10.0),
              ))),
          onPressed: clickHandler,
          child: Text(text,
              style: TextStyle(
                  fontSize: 14, color: enable ? Colors.white : Colors.black)));

  Widget sociaMediaIcons(String iconPath, Function clickHandler, String url,
          {double width = 24}) =>
      InkWell(
        onTap: clickHandler,
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle),
          padding: const EdgeInsets.all(20.0),
          child: SvgPicture.asset(iconPath,
              width: width,
              color: url != null && url != "" ? null : Colors.grey),
        ),
      );

  Widget _engagementCard(String val, String label) => Column(
        children: [
          Text(val, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle())
        ],
      );

  Widget _achievementCard(String label, String detail, Color color) => Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
          padding: EdgeInsets.all(10),
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Text(detail,
                  style: TextStyle(
                    color: Colors.white,
                  ))
            ],
          )));

  List<Widget> specialization(TrainerDetails details) {
    return [
      Padding(
        padding: EdgeInsets.fromLTRB(8, 20, 8, 12),
        child: Text("Specialization",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            )),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
            spacing: 10,
            runSpacing: 5,
            // direction: Axis.horizontal,
            children: details.specialization.asMap().entries.map((entry) {
              return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(234, 234, 235, 1),
                ),
                child: Text(entry.value,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Color.fromRGBO(54, 53, 52, 1))),
              );
            }).toList()),
      )
    ];
  }
}
