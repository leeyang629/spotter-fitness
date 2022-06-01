import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spotter/Components/common/LoadingIndicator.dart';
import 'package:spotter/Components/common/chip_list.dart';
import 'package:spotter/Components/common/dialog.dart';
import 'package:spotter/Components/common/profilePic.dart';
import 'package:spotter/Components/common/slide_container.dart';
import 'package:spotter/Components/screens/layout/Layout.dart';
import 'package:spotter/Components/screens/profile_setup/common/capture_image.dart';
import 'package:spotter/Components/screens/user_profile/model.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:spotter/utils/upload_image.dart';
import 'package:spotter/utils/userDataLoad.dart';
import 'package:flutter/foundation.dart';

class UserProfile extends StatefulWidget {
  final String permalink;
  final bool update;
  UserProfile(this.permalink, {this.update = false});

  @override
  ComponentState createState() => ComponentState();
}

class ComponentState extends State<UserProfile> {
  File _image;
  bool editImage = false;
  Future<UserDetails> response;
  // static const MethodChannel _channel = const MethodChannel('stripe_payment');
  @override
  void initState() {
    super.initState();
    response = loadUserData();
  }

  Future<UserDetails> loadUserData() async {
    final result = await fetchUserData(context, widget.permalink);
    return UserDetails.fromJson(
        result["onboardedInformation"]["onboarding_information"]);
  }

  updateImageFile(File updatedImageFile) {
    setState(() {
      _image = updatedImageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: response,
        builder: (BuildContext context, AsyncSnapshot<UserDetails> snapshot) {
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
                              response = loadUserData();
                            });
                            Navigator.pop(context);
                          }, "Error fetching user data"));
                  return Container();
                }
              }
              return userDetails(snapshot.data);
            default:
              if (snapshot.hasError) {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => errorDialog(context, () {
                          setState(() {});
                          Navigator.pop(context);
                        }, "Error fetching user data"));
                return Container();
              } else {
                return userDetails(snapshot.data);
              }
          }
        });
  }

  Widget userDetails(UserDetails details) {
    return Layout(
      Stack(children: [
        SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                      padding: EdgeInsets.only(top: 10, left: 10),
                      alignment: Alignment.topLeft,
                      color: Color.fromRGBO(216, 216, 216, 1),
                      height: MediaQuery.of(context).size.height * 0.22,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.arrow_back)),
                            if (widget.update)
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/update_user_profile_setup');
                                  },
                                  child: Text('Edit'))
                          ])),
                  SizedBox(
                    height: 75,
                  ),
                  Text(Provider.of<AppState>(context, listen: false).userName,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(Provider.of<AppState>(context, listen: false).userEmail,
                      textAlign: TextAlign.center, style: TextStyle()),
                  // Padding(
                  //   padding: const EdgeInsets.all(12.0),
                  //   child: Flex(
                  //       direction: Axis.horizontal,
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Flexible(
                  //           fit: FlexFit.tight,
                  //           child: roundClickButton(
                  //               Color.fromRGBO(112, 116, 119, 1),
                  //               "234 GYM VISITS",
                  //               () {}),
                  //         ),
                  //         SizedBox(
                  //           width: 20,
                  //         ),
                  //         Flexible(
                  //           fit: FlexFit.tight,
                  //           child: roundClickButton(
                  //               Color.fromRGBO(209, 130, 23, 1),
                  //               "40 SPOTTED",
                  //               () {}),
                  //         )
                  //       ]),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(12.0),
                  //   child: Text('About me',
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold,
                  //       )),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 28.0, right: 12),
                  //   child: Text("-"),
                  // ),

                  ...chipList("Gender", [details.gender.toUpperCase()]),
                  ...chipList("Experience", [details.experience.toUpperCase()]),
                  ...chipList("Goals", details.personalGoals),
                  ...chipList("Preferred WorkOuts", details.preferredWorkouts)
                ],
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.5 - 75,
                top: MediaQuery.of(context).size.height * 0.22 - 75,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      editImage = true;
                    });
                  },
                  child: ProfilePic(
                    150,
                    imageUrl: Provider.of<AppState>(context).userImgUrl,
                    cache: true,
                    color: Colors.black,
                    showEditIcon: true,
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
                  });
                }
              },
              child: Container(
                  alignment: Alignment.center,
                  child: CaptureImage(_image, updateImageFile, null, null)))
      ]),
      headerVisible: false,
      noPadding: true,
    );
  }
}
