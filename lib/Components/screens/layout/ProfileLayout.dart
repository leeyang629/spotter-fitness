import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:spotter/Components/common/LoadingIndicator.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProfileLayout extends StatelessWidget {
  final Widget body;
  bool headerVisible = true;
  final bool noPadding;
  final PreferredSizeWidget appBar;
  final bool topSafe;
  final bool bottomSafe;
  int totalPageCount;
  int activePageCount;

  ProfileLayout(this.body,
      {this.headerVisible = true,
      this.noPadding = false,
      this.appBar,
      this.topSafe = true,
      this.bottomSafe = true,
      this.totalPageCount = 0,
      this.activePageCount = 0,
      });
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
                    (activePageCount+1!=totalPageCount) ?Row(
                          children: [
                            SvgPicture.asset(
                              "assets/images/back.svg",
                              width: 30,
                              height: 30,
                            ),
                            Padding(padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/(totalPageCount*2))),
                            Expanded(
                                child:
                                _progress(context, activePageCount, totalPageCount)
                            )
                          ],
                        ):Container(),
                    Padding(padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0)),
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
  Widget _progress(BuildContext context, int index, int totalPageCount) =>
      Row(
      children: List<int>.filled(totalPageCount, 0)
            .asMap()
            .entries
            .map((entry) => Container(
            child:
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: SvgPicture.asset(
                "assets/images/line_inactive.svg",
                width: MediaQuery.of(context).size.width/(totalPageCount*2),
                color: index == entry.key
                    ? Color.fromRGBO(210, 184, 149, 1)
                    : Color.fromRGBO(210, 184, 149, 0.4),
              ),
            )
        )
      )
      .toList(),
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      );
}
