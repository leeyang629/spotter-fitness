import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'web_view_container.dart';
import 'package:flutter/services.dart';
import 'package:spotter/Components/common/SnackBar.dart';
import 'package:spotter/Components/screens/layout/BottomMenu.dart';
import 'package:spotter/Components/common/LoadingIndicator.dart';
import 'package:spotter/Components/screens/layout/MenuSliderWrapper.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:provider/provider.dart';

class LayoutWithUser extends StatefulWidget {
  final Widget body;
  final bool noPadding;
  final bool bottomMenu;
  LayoutWithUser(this.body, {this.noPadding = false, this.bottomMenu = true});
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<LayoutWithUser> with TickerProviderStateMixin {
  String menuState = 'close';
  AnimationController openMenuController;
  @override
  void initState() {
    super.initState();
    openMenuController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
  }

  updateMenuState(String value) {
    setState(() {
      menuState = value;
    });
    if (value == 'open') {
      openMenuController?.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 243, 246, 1),
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus.unfocus();
              },
              child: LayoutBuilder(
                  builder: (context, constraints) => Container(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: Column(children: [
                          Expanded(
                            child: Container(
                              padding: widget.noPadding
                                  ? EdgeInsets.all(0)
                                  : EdgeInsets.all(30.0),
                              child: widget.body,
                            ),
                          ),
                          if (widget.bottomMenu)
                            BottomMenu(menuState, updateMenuState)
                        ]),
                      )),
            ),
            if (widget.bottomMenu) SpotBackground(),
            if (widget.bottomMenu) Spot(),
            // Background click handler to close menu
            if (menuState == 'open')
              GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    updateMenuState('close');
                    openMenuController?.reverse();
                  },
                  child: Opacity(
                      opacity: 0.5,
                      child: Container(
                        color: Colors.black,
                      ))),
            MenuSliderWrapper(
                menuState: menuState,
                updateMenuState: updateMenuState,
                openMenuController: openMenuController),
            Provider.of<AppState>(context).spinner
                ? LoadingIndicator()
                : Container(),
            if (Provider.of<AppState>(context).showSnackBar)
              Positioned(
                bottom: 30,
                width: MediaQuery.of(context).size.width,
                child: Center(child: SnackBarCustom()),
              )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// void _handleURLButtonPress(BuildContext context) {
//   Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) =>
//               WebViewContainer('./user_profile/index.html')));
// }
