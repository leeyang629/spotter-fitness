import 'package:flutter/material.dart';
import 'package:spotter/Components/common/profilePic.dart';
import 'package:spotter/Components/screens/layout/LayoutWithUser.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/core/http.dart';
import 'package:spotter/core/storage.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  @override
  ComponentState createState() => ComponentState();
}

class ComponentState extends State<Settings> {
  bool notifications = false;
  double radius = 5;
  @override
  void initState() {
    super.initState();
    notifications = Provider.of<AppState>(context, listen: false).notifications;
    radius = Provider.of<AppState>(context, listen: false).radius;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWithUser(
      SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 20, 10, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back)),
                Expanded(
                    child: Text("Settings",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)))
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  ProfilePic(
                    75,
                    color: Colors.black,
                    imageUrl: Provider.of<AppState>(context).userImgUrl,
                    cache: true,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                          Provider.of<AppState>(context, listen: false)
                              .userName,
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, '/user_profile_update', arguments: {
                              "permalink":
                                  Provider.of<AppState>(context, listen: false)
                                      .userPermalink
                            });
                          },
                          child: Icon(Icons.edit_outlined)))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    size: 28,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child:
                          Text("Notifications", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  Switch(
                    value: notifications,
                    onChanged: (bool value) {
                      setState(() {
                        notifications = value;
                      });
                    },
                    activeColor: Color.fromRGBO(247, 165, 4, 1),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    size: 28,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text('Spotter Radius (${radius.toInt()} mi)',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: Slider(
                      activeColor: Color.fromRGBO(247, 165, 4, 1),
                      min: 5,
                      max: 50,
                      divisions: 45,
                      label: radius.round().toString(),
                      value: radius,
                      onChanged: (value) {
                        setState(() {
                          radius = value;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: saveButton(),
            )
          ],
        ),
      ),
      noPadding: true,
    );
  }

  Widget saveButton() => ElevatedButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(16)),
          backgroundColor:
              MaterialStateProperty.all<Color>(Color.fromRGBO(216, 150, 21, 1)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ))),
      onPressed: saveSettings,
      child: Text("Save", style: TextStyle(fontSize: 14, color: Colors.white)));

  saveSettings() async {
    try {
      final SecureStorage storage = SecureStorage();
      final api = HttpClient(productionApiUrls.user);
      Provider.of<AppState>(context, listen: false).enableSpinner();
      final result = await api.post("/api/v1/users/update_settings",
          {"notification": notifications, "radius": radius},
          withAuthHeaders: true);
      print(result);
      if (result['statusCode'] == 200) {
        await storage.saveRadius(radius.toString());
        await storage.saveNotifications(notifications.toString());
        Provider.of<AppState>(context, listen: false)
            .saveNotifications(notifications);
        Provider.of<AppState>(context, listen: false).saveRadius(radius);
        Provider.of<AppState>(context, listen: false)
            .displaySnackBar("Settings saved.");
      }
      Provider.of<AppState>(context, listen: false).disableSpinner();
    } catch (e) {
      print('error - $e');
      Provider.of<AppState>(context, listen: false).disableSpinner();
    }
  }
}
