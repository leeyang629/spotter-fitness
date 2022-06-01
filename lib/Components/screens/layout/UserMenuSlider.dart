import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/core/http.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/notification_utils/unregister_notifications.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:spotter/core/storage.dart';

class UserMenu extends StatefulWidget {
  MenuSliderState createState() => MenuSliderState();
}

class MenuSliderState extends State<UserMenu> with TickerProviderStateMixin {
  final SecureStorage storage = SecureStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return menuBar(context);
  }

  Widget menuBar(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 70,
                ),
                // Container(
                //   padding: const EdgeInsets.only(top: 15, bottom: 15),
                //   child: Text('Home',
                //       textAlign: TextAlign.center,
                //       style:
                //           TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                // ),
                // InkWell(
                //   onTap: () {
                //     Navigator.pushNamed(context, '/discover_activities');
                //   },
                //   child: Container(
                //     padding: const EdgeInsets.only(top: 15, bottom: 15),
                //     child: Text('Discover',
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //             fontSize: 16, fontWeight: FontWeight.w600)),
                //   ),
                // ),
                // InkWell(
                //     onTap: () {
                //       // widget.updateMenuState('close');
                //       Navigator.pushNamed(context, '/user_profile');
                //     },
                //     child: Container(
                //       padding: const EdgeInsets.only(top: 15, bottom: 15),
                //       child: Text('Profile',
                //           textAlign: TextAlign.center,
                //           style: TextStyle(
                //               fontSize: 16, fontWeight: FontWeight.w600)),
                //     )),
                // Container(
                //   padding: const EdgeInsets.only(top: 15, bottom: 15),
                //   child: Text('Activity',
                //       textAlign: TextAlign.center,
                //       style:
                //           TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                // ),
                Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/purchases");
                      },
                      child: Text('Purchases',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    )),
                Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: GestureDetector(
                      onTap: logout,
                      child: Text('Logout',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  child: Icon(
                    Icons.settings,
                    size: 28,
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  child: Text(
                    "Settings",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> logout() async {
    try {
      final apicall = HttpClient(productionApiUrls.user);
      Provider.of<AppState>(context, listen: false).enableSpinner();
      final result =
          await apicall.post("/api/v1/users/logout", {}, withAuthHeaders: true);
      print(result);
      if (result['statusCode'] == 200) {
        await unRegsiterNotifications();
        Provider.of<AppState>(context, listen: false).disableSpinner();
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      Provider.of<AppState>(context, listen: false).disableSpinner();
      print('error');
      print(e);
    }
  }
}
