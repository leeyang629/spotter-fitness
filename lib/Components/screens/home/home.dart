import 'package:flutter/material.dart';
import 'package:spotter/Components/common/LoadingIndicator.dart';
import 'package:spotter/Components/common/dialog.dart';
import 'package:spotter/utils/userDataLoad.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State {
  Future response;
  @override
  void initState() {
    super.initState();
    response = getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: response,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            goToLoginPage(context);
            return Stack(
              children: [
                Image.asset(
                  "assets/images/splash_screen.png",
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                LoadingIndicator()
              ],
            );
          case ConnectionState.done:
            if (snapshot.hasError) {
              print("error");
              print(snapshot.error.toString());
              if (snapshot.error.toString() == "Exception: Invalid session") {
                goToLoginPage(context);
                return Container();
              } else {
                // WidgetsBinding.instance
                //     .addPostFrameCallback((_) => errorDialog(context, () {
                //           setState(() {
                //             response = getUserData(context);
                //           });
                //           Navigator.pop(context);
                //         }, "Error fetching user data"));
                goToLoginPage(context);
                return Container();
              }
            }
            return Stack(
              children: [
                Image.asset("assets/images/splash_screen.png",
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height),
                LoadingIndicator()
              ],
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
              return Stack(
                children: [
                  Image.asset("assets/images/splash_screen.png",
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height),
                  LoadingIndicator()
                ],
              );
            }
        }
      },
    );
  }
}
