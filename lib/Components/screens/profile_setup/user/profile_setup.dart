import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/Components/screens/layout/ProfileLayout.dart';
import 'package:spotter/Components/screens/profile_setup/common/capture_image.dart';
import 'package:spotter/Components/screens/profile_setup/common/gender_select.dart';
import 'package:spotter/Components/screens/profile_setup/common/bottom_section.dart';
import 'package:spotter/Components/screens/profile_setup/user/experience.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:spotter/utils/userDataLoad.dart';
import '../../layout/Layout.dart';
import 'personal_goal.dart';
import 'preferred_workouts.dart';
import 'package:spotter/Components/screens/profile_setup/common/finish_screen.dart';
import 'package:http/http.dart' as http;
import 'package:spotter/core/endpoints.dart';
import 'dart:io';
import 'package:spotter/core/storage.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

class UserProfileSetup extends StatefulWidget {
  final bool update;
  final bool register;
  UserProfileSetup({this.update = false, this.register = false});
  @override
  QuestionState createState() => QuestionState();
}

class QuestionState extends State<UserProfileSetup> {
  int index = 0;
  int totalPageCount = 6;
  List<String> personalGoal = [];
  String experience = "";
  bool enableButton = false;
  String gender = "";
  List<String> favouriteWorkouts = [];
  File _image;
  final SecureStorage storage = SecureStorage();
  Map<String, dynamic> onBoardData = {
    "gender": "",
    "experience": "",
    "personalGoals": [],
    "preferredWorkouts": []
  };

  @override
  void initState() {
    super.initState();
    if (widget.update || widget.register) {
      loadOnboardData();
    }
    if (widget.register)
    {
      onBoardData = {
        "experience": "",
        "personalGoals": [],
        "preferredWorkouts": []
      };
      totalPageCount = 4;
    }
  }

  loadOnboardData() async {
    final SecureStorage storage = SecureStorage();
    final permalink = await storage.getPermalink();
    final userData = await fetchUserData(context, permalink);
    final onboardingData =
        userData["onboardedInformation"]["onboarding_information"];
    print(onboardingData);
    if (onboardingData != null && onboardingData != "" && onBoardData != {}) {
      setState(() {
        gender = onboardingData["gender"];
        onBoardData = onboardingData;
        onBoardData["preferredWorkouts"] =
            onboardingData["preferredWorkouts"]?.cast<String>();
        onBoardData["personalGoals"] =
            onboardingData["personalGoals"]?.cast<String>();
        onBoardData["experience"] = onboardingData["experience"];
        experience = onboardingData["experience"];
      });
    }
    print(onBoardData);
  }

  finishedOnboarding() {
    setState(() {
      enableButton = true;
    });
  }

  changeGender(String value) {
    setState(() {
      gender = value;
    });
    onBoardData["gender"] = value;
  }

  updateImageFile(File updatedImageFile) {
    setState(() {
      _image = updatedImageFile;
    });
  }

  updateFavWorkouts(List<String> value) {
    onBoardData["preferredWorkouts"] = value;
  }

  @override
  Widget build(BuildContext context) {
    return ProfileLayout(
      LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: constraint.maxHeight),
              child: Container(
                decoration: BoxDecoration(
                  gradient: index == 5
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
                  rowSizes: [_title() != "" ? 48.px : 0.px, 1.fr, 0.px, 48.px],
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
                        )),
                    GridPlacement(
                        columnStart: 0,
                        columnSpan: 1,
                        rowStart: 1,
                        rowSpan: 1,
                        child: Container(
                          alignment: index == 5
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
                          nextHandler, () {}, enableButton),
                    )
                  ],
                ),
              )),
        );
      }),
      headerVisible: false,
      noPadding: index == 5,
      totalPageCount: totalPageCount,
      activePageCount: index,
    );
  }

  String description() {
    if(!widget.register)
      switch (index) {
        case 0:
          return 'To give you a better experience, we need to know your Gender';
        case 1:
          return '';
        case 2:
          return '';
        case 3:
          return "";
        case 4:
          return '';
        default:
          return 'We want to know more about you. Please follow these next steps to complete the information.';
      }
    else
      return '';
  }

  String _title() {
    if(!widget.register)
      switch (index) {
        case 0:
          return 'Gender';
        case 1:
        case 2:
          return '';
        case 3:
          return '';
        case 4:
          return "Profile Picture";
        case 5:
          return '';
        default:
          return 'About You';
      }
    else
      return '';
  }

  void setGoalsSelected(List<String> value) {
    setState(() {
      onBoardData["personalGoals"] = value;
    });
  }

  void setExperienceSelected(String value) {
    setState(() {
      experience = value;
    });
    onBoardData["experience"] = value;
  }

  Widget onBoardingComponent() {
    if(!widget.register)
      switch (index) {
        case 0:
          return GenderSelect(gender, changeGender);
        case 1:
          return Experience(experience, setExperienceSelected);
        case 2:
          return PersonalGoal(setGoalsSelected,
              savedGoals: onBoardData["personalGoals"]?.cast<String>());
        case 3:
          return PreferredWorkouts(
            updateFavWorkouts,
            savedWorkouts: onBoardData["preferredWorkouts"]?.cast<String>(),
          );
        case 4:
          return CaptureImage(_image, updateImageFile, null, null);
        case 5:
          return Finish(finishedOnboarding,
              {"data": onBoardData, "organisationPermalink": null});
        default:
          return Experience(experience, setExperienceSelected);
      }
    else
      switch (index) {
        case 0:
          return Experience(experience, setExperienceSelected);
        case 1:
          return PersonalGoal(setGoalsSelected,
              savedGoals: onBoardData["personalGoals"]?.cast<String>());
        case 2:
          return PreferredWorkouts(
            updateFavWorkouts,
            savedWorkouts: onBoardData["preferredWorkouts"]?.cast<String>(),
          );
        case 3:
          return Finish(finishedOnboarding,
              {"data": onBoardData, "organisationPermalink": null, "register": widget.register});
        default:
          return Experience(experience, setExperienceSelected);
      }

  }

  void skipHandler() {
    setState(() {
      index = totalPageCount - 1;
    });
  }

  void nextHandler() async {
    if (index == 3 && widget.update) {
      setState(() {
        index += 2;
      });
      return;
    }
    if (index == 4 && _image != null) {
      print("uploading image");
      await upload();
    }
    setState(() {
      index++;
    });
  }

  upload() async {
    try {
      Provider.of<AppState>(context, listen: false).enableSpinner();
      var request = http.MultipartRequest('POST',
          Uri.parse('${productionApiUrls.user}/api/v1/users/profile_picture'));
      String token = await storage.getUserToken();
      String permalink = await storage.getPermalink();
      String deviceId = await storage.getDeviceId();
      request.headers["Authorization"] = 'Bearer $token';
      request.headers["SpotterUserId"] = permalink;
      request.headers["SpotterDeviceId"] = deviceId;
      request.files
          .add(await http.MultipartFile.fromPath('image', _image.path));
      var res = await request.send();

      var response = jsonDecode(await res.stream.bytesToString());
      if (response["statusCode"] == 200) {
        Provider.of<AppState>(context, listen: false).disableSpinner();
        await storage.saveUserImgUrl(response["url"]);
        Provider.of<AppState>(context, listen: false)
            .setUserImgUrl(response["url"]);
      }
    } catch (e) {
      print("error");
      print(e);
    }
  }
}
