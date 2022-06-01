import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:spotter/Components/common/LoadingIndicator.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Layout extends StatelessWidget {
  final Widget body;
  bool headerVisible = true;
  final bool noPadding;
  final PreferredSizeWidget appBar;
  final bool topSafe;
  final bool bottomSafe;
  Layout(this.body,
      {this.headerVisible = true,
      this.noPadding = false,
      this.appBar,
      this.topSafe = true,
      this.bottomSafe = true});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: appBar,
      backgroundColor: Color.fromRGBO(245, 245, 246, 1),
      body: SafeArea(
        top: topSafe,
        bottom: bottomSafe,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus.unfocus();
              },
              child: Container(
                color: Color.fromRGBO(15, 21, 35, 1),
                padding: noPadding
                    ? EdgeInsets.all(0)
                    : EdgeInsets.fromLTRB(30.0, 60.0, 30.0, 40.0),
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    headerVisible == true
                        ? SvgPicture.asset(
                            "assets/images/logo_text.svg",
                            width: 108,
                            height: 82,
                          )
                        : Container(),
                    Padding(padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0)),
                    Text(
                      "SPOTTER".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                        child: Container(
                      child: body,
                    )),
                  ],
                ),
              ),
            ),
            Provider.of<AppState>(context).spinner
                ? LoadingIndicator()
                : Container()
          ],
        ),
      ),
    );
  }
}
