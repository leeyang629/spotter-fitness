import 'package:flutter/material.dart';
import 'package:spotter/Components/common/dialog.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/core/http.dart';
import 'package:spotter/utils/utils.dart';

class UpdateApp extends StatefulWidget {
  final Widget child;
  UpdateApp({this.child});
  @override
  State<UpdateApp> createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> {
  String appVersion = "0";
  String minVersion = "0";
  String latestPlayStoreVersion = "0";
  @override
  void initState() {
    super.initState();
    //Fetch App version;
    Future.delayed(Duration.zero, () {
      // checkAppVersion(context);
    });
  }

  checkAppVersion(BuildContext context) async {
    final api = HttpClient(productionApiUrls.user);
    try {
      final result = await api.get("/versions");
      print(result);
    } catch (e) {
      print(e);
    }
    if (int.parse(minVersion) > int.parse(appVersion)) {
      popupDialog(
          context,
          "App Update Available",
          "Please update the App to continue.",
          [
            TextButton(
                onPressed: () {
                  // launchUrl(
                  //     "https://play.google.com/store/apps/details?id=com.camsilu.spotter");
                  Navigator.pop(context);
                },
                child: Text("Update Now"))
          ],
          barrierDismissible: false);
    } else if (int.parse(latestPlayStoreVersion) > int.parse(appVersion)) {
      popupDialog(
          context,
          "App Update Available",
          "A newer version of the app is available",
          [
            TextButton(
                onPressed: () {
                  launchUrl(
                      "https://play.google.com/store/apps/details?id=com.camsilu.spotter");
                },
                child: Text("Update Now")),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Later"),
            )
          ],
          barrierDismissible: false);
    } else
      popupDialog(
          context,
          "App Update Available",
          "A newer version of the app is available",
          [
            TextButton(
                onPressed: () {
                  launchUrl(
                      "https://play.google.com/store/apps/details?id=com.camsilu.spotter");
                },
                child: Text("Update Now")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Later"))
          ],
          barrierDismissible: false);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
