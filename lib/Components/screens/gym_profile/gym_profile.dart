import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:spotter/Components/common/LoadingIndicator.dart';

import 'package:spotter/Components/common/dialog.dart';
import 'package:spotter/Components/common/slide_container.dart';
import 'package:spotter/Components/screens/layout/Layout.dart';
import 'package:spotter/Components/screens/map/gym_details.dart';
import 'package:spotter/Components/screens/map/gyms_list.dart';
import 'package:spotter/Components/screens/profile_setup/common/capture_image.dart';
import 'package:spotter/utils/upload_image.dart';
import 'package:spotter/utils/userDataLoad.dart';
import 'package:spotter/utils/utils.dart';

class GymProfile extends StatefulWidget {
  final String permalink;
  final bool update;
  GymProfile(this.permalink, {this.update = false});
  @override
  _GymProfileState createState() => _GymProfileState();
}

class _GymProfileState extends State<GymProfile> {
  Future<GymLocation> response;
  List<XFile> _images;
  bool editImage = false;
  Timer deboundTimer;
  @override
  void initState() {
    super.initState();
    response = fetchGymDetails();
  }

  updateImageFile(List<XFile> updatedImageFile) {
    setState(() {
      _images = updatedImageFile;
    });
  }

  Future<GymLocation> fetchGymDetails() async {
    return GymLocation.fromJson({
      "onboardedInformations": await getGymDetails(context, widget.permalink)
    }, spotterOnboarded: true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: response,
        builder: (BuildContext context, AsyncSnapshot<GymLocation> snapshot) {
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
                              response = fetchGymDetails();
                            });
                            Navigator.pop(context);
                          }, "Error fetching trainer data"));
                  return Container();
                }
              }
              return Layout(
                Stack(
                  children: [
                    GymDetails(
                        openGymDetails: true,
                        selectedGymDetails: snapshot.data,
                        update: true,
                        setOpenGymDetails: (_) {
                          Navigator.pop(context);
                        },
                        openImageEdit: () {
                          setState(() {
                            editImage = true;
                          });
                        }),
                    if (editImage)
                      SliderContainer(
                        open: editImage,
                        close: () async {
                          setState(() {
                            editImage = false;
                          });
                          if (isNotEmpty(_images)) {
                            await uploadMultiImages(context, _images);
                            setState(() {
                              _images = [];
                            });
                            setState(() {
                              response = fetchGymDetails();
                            });
                          }
                        },
                        child: Container(
                            alignment: Alignment.center,
                            child: CaptureImage(
                                null, null, _images, updateImageFile)),
                      )
                  ],
                ),
                headerVisible: false,
                noPadding: true,
              );
            default:
              if (snapshot.hasError) {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => errorDialog(context, () {
                          setState(() {});
                          Navigator.pop(context);
                        }, "Error fetching user data"));
                return Container();
              } else {
                return Scaffold(
                    body: new GymDetails(
                        openGymDetails: true,
                        selectedGymDetails: snapshot.data,
                        update: true,
                        setOpenGymDetails: (_) {
                          Navigator.pop(context);
                        }));
              }
          }
        });
  }
}
