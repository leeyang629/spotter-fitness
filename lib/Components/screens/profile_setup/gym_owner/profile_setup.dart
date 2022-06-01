import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:spotter/Components/common/dialog.dart';
import 'package:spotter/Components/screens/profile_setup/common/capture_image.dart';
import 'package:spotter/Components/screens/profile_setup/common/set_location.dart';
import 'package:spotter/Components/screens/profile_setup/gym_owner/onboarding_questions.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/core/storage.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:spotter/utils/upload_image.dart';
import 'package:spotter/utils/userDataLoad.dart';
import 'package:spotter/utils/utils.dart';
import '../../layout/Layout.dart';
import 'package:spotter/Components/screens/profile_setup/common/bottom_section.dart';
import 'package:spotter/Components/screens/profile_setup/common/finish_screen.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import "./questions_data.dart";
import 'package:spotter/core/http.dart';

class GymOwnerProfileSetup extends StatefulWidget {
  final bool update;
  GymOwnerProfileSetup({this.update = false});
  @override
  QuestionState createState() => QuestionState();
}

class QuestionState extends State<GymOwnerProfileSetup> {
  int index = 0;
  int totalPageCount = 8;
  bool enableButton = false;
  bool disableSkipNext = false;
  Map<String, String> socialMedia = {};
  List<XFile> _images;
  Map<String, double> location = {"latitude": 0, "longitude": 0};
  final Map<String, dynamic> initial = {};
  Map<String, dynamic> onBoardData = {
    "otherInformation": {"socialMedia": {}}
  };
  final SecureStorage storage = SecureStorage();

  @override
  void initState() {
    super.initState();
    if (index == 0 && location["latitude"] == 0 && location["longitude"] == 0) {
      setState(() {
        disableSkipNext = true;
      });
    }
    if (widget.update) {
      loadOnboardData();
    }
  }

  loadOnboardData() async {
    try {
      final SecureStorage storage = SecureStorage();
      final companyId = await storage.getCompanyPermalink();
      Provider.of<AppState>(context, listen: false).enableSpinner();
      final gymData = await getGymDetails(context, companyId);
      Provider.of<AppState>(context, listen: false).disableSpinner();
      // print(gymData["otherInformation"] ?? {});
      final Map<String, dynamic> initialOthers = {"socialMedia": {}};
      setState(() {
        // onBoardData = gymData;
        onBoardData = gymData;
        onBoardData["otherInformation"] =
            gymData["otherInformation"] ?? initialOthers;
        if (isNotEmpty(gymData["latitude"]) &&
            isNotEmpty(gymData["longitude"])) {
          location = {
            "latitude": gymData["latitude"],
            "longitude": gymData["longitude"]
          };
        }

        disableSkipNext = false;
      });
      print(onBoardData);
    } catch (e) {
      Provider.of<AppState>(context, listen: false).disableSpinner();
    }
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
      if (isNotEmpty(onBoardData["otherInformation"]["socialMedia"])) {
        setState(() {
          onBoardData["otherInformation"]["socialMedia"][arr[0]] = arr[1];
        });
      } else {
        setState(() {
          onBoardData["otherInformation"]["socialMedia"] = {arr[0]: arr[1]};
        });
      }
    } else {
      if (questionIndex == 0) {
        if (value != "" && value != null) {
          setState(() {
            disableSkipNext = false;
          });
        } else
          setState(() {
            disableSkipNext = true;
          });
      }
      setState(() {
        if (questions[questionIndex]["other"]) {
          onBoardData["otherInformation"]
              [questions[questionIndex]["attribute"]] = value;
        } else {
          onBoardData[questions[questionIndex]["attribute"]] = value;
        }
      });
    }
  }

  updateImageFile(List<XFile> updatedImageFile) {
    setState(() {
      _images = updatedImageFile;
    });
  }

  Widget build(BuildContext context) {
    return Layout(
      LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: constraint.maxHeight,
                    minHeight: constraint.maxHeight),
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
                    rowSizes: [36.px, 1.fr, 0.px, 48.px],
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
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0)),
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
                              child: onBoardingComponent())),
                      GridPlacement(
                          columnStart: 0,
                          columnSpan: 1,
                          rowStart: 2,
                          rowSpan: 1,
                          child: Text("",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500))),
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
    );
  }

  String _title() {
    switch (index) {
      case 0:
        return 'Share location to be identified';
      case 1:
        return 'LET’S GET STARTED!';
      case 2:
      case 3:
      case 4:
      case 5:
        return 'TELL US ABOUT YOUR GYM';
      case 6:
        return "";
    }
    return "";
  }

  Widget onBoardingComponent() {
    switch (index) {
      case 0:
        return SetLocationWrapper(
          commonChangeHandler,
          location: location,
        );
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
        return OnboardingQuestions(index, commonChangeHandler, onBoardData);
      case 6:
        return CaptureImage(null, null, _images, updateImageFile);
      case 7:
        return Finish(finishedOnboarding, buildOnboardingResponse());
    }
    return Container();
  }

  buildOnboardingResponse() {
    final data = {
      ...onBoardData,
      "email": Provider.of<AppState>(context, listen: false).userEmail ?? ""
    };
    print(data);
    return {
      ...onBoardData,
      "email": Provider.of<AppState>(context, listen: false).userEmail ?? ""
    };
  }

  void nextHandler() async {
    if (index == 0 &&
        (onBoardData["name"] == "" || onBoardData["name"] == null)) {
      setState(() {
        disableSkipNext = true;
      });
    }
    if (index == 5) {
      if (widget.update)
        await updateGymOnboarding();
      else
        await gymOnboarding();
      if (widget.update) {
        setState(() {
          index += 2;
        });
        return;
      }
    }
    if (index == 6 && _images != null) {
      print("uploading image");
      await uploadMultiImages(context, _images);
    }
    setState(() {
      index++;
    });
  }

  void skipHandler() async {
    if (onBoardData["name"] == "" || onBoardData["name"] == null) {
      return null;
    }
    if (index <= 5) {
      if (widget.update)
        await updateGymOnboarding();
      else
        await gymOnboarding();
    }
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

  Future<dynamic> gymOnboarding() async {
    final api = HttpClient(productionApiUrls.company);
    try {
      Provider.of<AppState>(context, listen: false).enableSpinner();
      api.headers["content-type"] = "application/json";
      final result = await api.post("/companies", buildOnboardingResponse(),
          withAuthHeaders: true);
      if (result["statusCode"] == 200) {
        print(result);
        Provider.of<AppState>(context, listen: false).disableSpinner();
        await storage.saveCompanyPermalink(result["id"]);
        await storage.saveUsername(onBoardData["name"]);
        Provider.of<AppState>(context, listen: false)
            .setUserName(onBoardData["name"]);
      }
    } catch (e) {
      Provider.of<AppState>(context, listen: false).disableSpinner();
      print("error");
      print(e);
      errorDialog(context, () {
        gymOnboarding();
        Navigator.pop(context);
      }, "Onboarding failed");
    }
  }

  Future<dynamic> updateGymOnboarding() async {
    final api = HttpClient(productionApiUrls.company);
    try {
      Provider.of<AppState>(context, listen: false).enableSpinner();
      final companyPermalink = await storage.getCompanyPermalink();
      api.headers["content-type"] = "application/json";
      final result = await api.patch(
          "/companies/$companyPermalink", buildOnboardingResponse(),
          withAuthHeaders: true);
      if (result["statusCode"] == 200) {
        print(result);
        Provider.of<AppState>(context, listen: false).disableSpinner();
        await storage.saveUsername(onBoardData["name"]);
        Provider.of<AppState>(context, listen: false)
            .setUserName(onBoardData["name"]);
      }
    } catch (e) {
      Provider.of<AppState>(context, listen: false).disableSpinner();
      print("error");
      print(e);
      errorDialog(context, () {
        updateGymOnboarding();
        Navigator.pop(context);
      }, "Onboarding failed");
    }
  }
}
