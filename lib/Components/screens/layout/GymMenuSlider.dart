import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/core/http.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:spotter/core/storage.dart';

class GymMenu extends StatefulWidget {
  MenuSliderState createState() => MenuSliderState();
}

class MenuSliderState extends State<GymMenu> with TickerProviderStateMixin {
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
                Container(
                    padding: const EdgeInsets.only(top: 75, bottom: 15),
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
        Provider.of<AppState>(context, listen: false).disableSpinner();
        await storage.deleteUserData();
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      Provider.of<AppState>(context, listen: false).disableSpinner();
      print('error');
      print(e);
    }
  }
}
