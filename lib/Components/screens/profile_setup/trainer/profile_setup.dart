import 'package:flutter/material.dart';
import 'package:spotter/Components/screens/layout/ProfileLayout.dart';

import 'package:spotter/Components/screens/profile_setup/common/set_location.dart';
import 'package:spotter/Components/screens/profile_setup/trainer/onboarding_questions.dart';

import 'package:spotter/core/storage.dart';

import 'package:spotter/utils/upload_image.dart';
import 'package:spotter/utils/userDataLoad.dart';
import '../../layout/Layout.dart';
import 'package:spotter/Components/screens/profile_setup/common/gender_select.dart';
import 'package:spotter/Components/screens/profile_setup/common/bottom_section.dart';
import 'package:spotter/Components/screens/profile_setup/common/finish_screen.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'dart:io';
import 'package:spotter/Components/screens/profile_setup/common/capture_image.dart';
import "./questions_data.dart";

class TrainerProfileSetup extends StatefulWidget {
  final bool update;
  final bool register;
  TrainerProfileSetup({this.update = false, this.register = false});
  @override
  OnboardingState createState() => OnboardingState();
}

class OnboardingState extends State<TrainerProfileSetup> {
  int index = 0;
  int totalPageCount = 8;
  bool enableButton = false;
  String gender = "";
  bool disableSkipNext = false;
  List<String> trainingTypes = [];
  Map<String, String> socialMedia = {};
  File _image;
  Map<String, double> location = {"latitude": 0, "longitude": 0};
  double latitude = 0;
  double longitude = 0;
  Map<String, dynamic> onBoardData = {"gender": "", "socialMedia": {}};
  final SecureStorage storage = SecureStorage();

  @override
  void initState() {
    super.initState();
    if (index == 0 && latitude == 0 && longitude == 0) {
      setState(() {
        disableSkipNext = true;
      });
    }
    if (widget.update || widget.register) {
      loadOnboardData();
    }
    if(widget.register)
      totalPageCount = 5;
      setState(() {
        disableSkipNext = false;
        setState(() {
          enableButton = true;
        });
      });
  }

  loadOnboardData() async {
    final SecureStorage storage = SecureStorage();
    final permalink = await storage.getPermalink();
    final userData = await fetchUserData(context, permalink);
    final onboardingData =
        userData["onboardedInformation"]["onboarding_information"];
    if (onboardingData != null && onboardingData != "" && onBoardData != {}) {
      setState(() {
        gender = onboardingData["gender"];
        onBoardData = {...onBoardData, ...onboardingData};
        location = {
          "latitude": onboardingData["latitude"],
          "longitude": onboardingData["longitude"]
        };
        disableSkipNext = false;
      });
    }
    print(onBoardData);
  }

  changeGender(String value) {
    setState(() {
      gender = value;
      onBoardData["gender"] = value;
    });
  }

  commonChangeHandler(int questionIndex, dynamic value) {
    if (questionIndex == 30) {
      onBoardData["latitude"] = value.latitude;
      onBoardData["longitude"] = value.longitude;
      setState(() {
        location = {"latitude": value.latitude, "longitude": value.longitude};
        disableSkipNext = false;
      });
    } else if (questions[questionIndex]["attribute"] == "socialMedia") {
      final arr = value.toString().split(' - ');
      setState(() {
        onBoardData["socialMedia"][arr[0]] = arr[1];
      });
    } else {
      setState(() {
        onBoardData[questions[questionIndex]["attribute"]] = value;
      });
    }
  }

  updateImageFile(File updatedImageFile) {
    setState(() {
      _image = updatedImageFile;
    });
  }

  Widget build(BuildContext context) {
    return ProfileLayout(
      LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: constraint.maxHeight,
                  // minHeight: constraint.maxHeight
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: index == 7
                        ? LinearGradient(
                            begin: Alignment(0, 1.0),
                            end: Alignment(0, -1.0),
                            colors: [
                              Color.fromRGBO(246, 207, 115, 1),
                              Color.fromRGBO(223, 151, 8, 1),
                            ],
                          )
                        : null,
                  ),
                  child: LayoutGrid(
                    gridFit: GridFit.passthrough,
                    rowSizes: [36.px, 1.fr, index == 1 ? 48.px : 0.px, 48.px],
                    columnSizes: [1.fr],
                    children: [
                      GridPlacement(
                        columnStart: 0,
                        columnSpan: 1,
                        rowStart: 0,
                        rowSpan: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(_title(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(210, 184, 149, 1),
                                  fontSize: 24)),
                        ),
                      ),
                      GridPlacement(
                          columnStart: 0,
                          columnSpan: 1,
                          rowStart: 1,
                          rowSpan: 1,
                          child: Container(
                            alignment: index == 7
                                ? Alignment.center
                                : Alignment.topCenter,
                            child: onBoardingComponent(),
                          )),
                      GridPlacement(
                          columnStart: 0,
                          columnSpan: 1,
                          rowStart: 2,
                          rowSpan: 1,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(description(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                          )),
                      GridPlacement(
                        columnStart: 0,
                        columnSpan: 1,
                        rowStart: 3,
                        rowSpan: 1,
                        child: bottomSection(index, totalPageCount, skipHandler,
                            nextHandler, () {}, enableButton,
                            disableSkipNext: disableSkipNext),
                      )
                    ],
                  ),
                )));
      }),
      headerVisible: false,
      noPadding: index == 7,
      totalPageCount: totalPageCount,
      activePageCount: index
    );
  }

  String _title() {
    if (!widget.register)
      switch (index) {
        case 0:
          return 'Share location to be identified';
        case 1:
          return 'Gender';
        case 2:
        case 3:
        case 4:
        case 5:
          return 'Tell us about you';
        case 6:
          return "";
      }
    else
      switch (index) {
        case 0:
        case 1:
        case 2:
        case 3:
          return 'Tell us about you';
        case 4:
          return "";
      }
      return "";
  }

  Widget onBoardingComponent() {
    if (!widget.register)
    switch (index) {
      case 0:
        return SetLocationWrapper(
          commonChangeHandler,
          location: location,
        );
      case 1:
        return GenderSelect(gender, changeGender);
      case 2:
      case 3:
      case 4:
      case 5:
        return OnboardingQuestions(index, commonChangeHandler, onBoardData);
      case 6:
        return CaptureImage(_image, updateImageFile, null, null);
      case 7:
        return Finish(finishedOnboarding, buildOnboardingResponse());
    }
    else
      switch (index) {
        case 0:
          return OnboardingQuestions(4, commonChangeHandler, onBoardData);
        case 1:
          return OnboardingQuestions(5, commonChangeHandler, onBoardData);
        case 2:
          return OnboardingQuestions(3, commonChangeHandler, onBoardData);
        case 3:
          return OnboardingQuestions(2, commonChangeHandler, onBoardData);
        case 4:
          Navigator.pushReplacementNamed(context, '/trainer_dashboard');
      }
    return Container();
  }

  buildOnboardingResponse() {
    return {
      "organisationPermalink": null,
      "data": onBoardData,
    };
  }

  String description() {
    switch (index) {
      case 0:
        return 'To give you a better experience, we need to know your Gender';
      case 1:
        return '';
      case 2:
        return '';
      case 3:
        return '';
      default:
        return '';
    }
  }

  void nextHandler() async {
    if (index == 5 && widget.update) {
      setState(() {
        index += 2;
      });
      return;
    }
    if (index == 6 && _image != null) {
      print("uploading image");
      await uploadImage(context, _image);
    }
    setState(() {
      index++;
    });
  }

  void skipHandler() {
    setState(() {
      index = 7;
    });
    // Navigator.pushReplacementNamed(context, '/trainers_list');
  }

  finishedOnboarding() {
    setState(() {
      enableButton = true;
    });
  }
}
