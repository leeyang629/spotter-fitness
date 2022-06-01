import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/Components/common/profilePic.dart';
import 'package:spotter/Components/screens/layout/GymMenuSlider.dart';
import 'package:spotter/Components/screens/layout/TrainerMenuSlider.dart';
import 'package:spotter/Components/screens/layout/UserMenuSlider.dart';
import 'package:spotter/core/http.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/notification_utils/unregister_notifications.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:spotter/core/storage.dart';

class MenuSliderWrapper extends StatefulWidget {
  final Widget child;
  final String menuState;
  final Function(String) updateMenuState;
  final AnimationController openMenuController;
  MenuSliderWrapper(
      {this.menuState,
      this.updateMenuState,
      this.openMenuController,
      this.child});

  @override
  MenuSliderState createState() => MenuSliderState();
}

class MenuSliderState extends State<MenuSliderWrapper>
    with TickerProviderStateMixin {
  Animation _openMenu;
  final SecureStorage storage = SecureStorage();

  @override
  void initState() {
    super.initState();
    _openMenu = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: widget.openMenuController, curve: Curves.easeInOutCubic));
  }

  @override
  Widget build(BuildContext context) {
    return menuBar(context);
  }

  Widget menuBar(BuildContext context) {
    return AnimatedBuilder(
        animation: _openMenu,
        builder: (context, child) => Container(
            transform: Matrix4.translationValues(
                MediaQuery.of(context).size.width * (1 - 0.6 * _openMenu.value),
                0,
                0),
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
              color: Color.fromRGBO(216, 216, 216, 1),
            ),
            child: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    height: MediaQuery.of(context).size.height * 0.18,
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  widget.updateMenuState('close');
                                  widget.openMenuController?.reverse();
                                })),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Provider.of<AppState>(context, listen: false)
                                .userName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  renderMenuItems()
                ],
              ),
              Positioned(
                  right: MediaQuery.of(context).size.width * 0.7 - 50,
                  top: MediaQuery.of(context).size.height * 0.18 - 50,
                  child: AnimatedBuilder(
                    animation: _openMenu,
                    builder: (context, child) => Container(
                      // padding: const EdgeInsets.all(10),
                      transform: Matrix4.translationValues(
                          MediaQuery.of(context).size.width *
                              (1 - 0.6 * _openMenu.value),
                          0,
                          0),
                      child: InkWell(
                        onTap: () {
                          openProfileScreen();
                        },
                        child: ProfilePic(
                          100,
                          color: Colors.black,
                          imageUrl:
                              Provider.of<AppState>(context, listen: false)
                                  .userImgUrl,
                          cache: true,
                          showEditIcon: true,
                        ),
                      ),
                    ),
                  ))
            ])));
  }

  openProfileScreen() async {
    switch (Provider.of<AppState>(context, listen: false).userPersona) {
      case "user":
        return Navigator.pushNamed(context, '/user_profile_update', arguments: {
          "permalink":
              Provider.of<AppState>(context, listen: false).userPermalink
        });
      case "trainer":
        return Navigator.pushNamed(context, '/trainer_profile_update',
            arguments: {
              "permalink":
                  Provider.of<AppState>(context, listen: false).userPermalink
            });
      case "owner":
        {
          final companyPermalink = await storage.getCompanyPermalink();
          return Navigator.pushNamed(context, '/gym_details_update',
              arguments: {"permalink": companyPermalink});
        }
    }
  }

  renderMenuItems() {
    switch (Provider.of<AppState>(context, listen: false).userPersona) {
      case "user":
        return UserMenu();
      case "trainer":
        return TrainerMenu();
      case "owner":
        return GymMenu();
    }
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
        Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
      }
    } catch (e) {
      Provider.of<AppState>(context, listen: false).disableSpinner();
      print('error');
      print(e);
    }
  }
}
