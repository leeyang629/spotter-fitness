import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:spotter/providers/app_state.dart';

class BottomMenu extends StatelessWidget {
  final String menuState;
  final Function(String) updateMenuState;
  BottomMenu(this.menuState, this.updateMenuState);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // border: Border(top: BorderSide(color: Colors.grey)),
        gradient: LinearGradient(
          begin: Alignment(0, 1.0),
          end: Alignment(0, -1.0),
          colors: [
            Color.fromRGBO(15, 21, 35, 1),
            Color.fromRGBO(15, 21, 35, 1)
          ],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      height: 66,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/map');
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              // child: SvgPicture.asset(
              //   'assets/images/gym.svg',
              //   width: 30,
              //   height: 30,
              //   color: Colors.black,
              // ),
              child: Icon(
                Icons.location_on_outlined,
                size: 30,
                color: Color.fromRGBO(210, 184, 149, 1),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/schedule');
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                Icons.menu,
                size: 30,
                color: Color.fromRGBO(210, 184, 149, 1),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // Navigator.pushNamed(context, '/schedule');
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: Icon(
                Icons.home,
                size: 30,
                color: Color.fromRGBO(210, 184, 149, 1),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/chat');
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Stack(children: [
                Icon(
                  Icons.message_outlined,
                  size: 30,
                  color: Color.fromRGBO(210, 184, 149, 1),
                ),
                if (Provider.of<AppState>(context).newMessage)
                  Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red),
                        height: 8,
                        width: 8,
                      ))
              ]),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (menuState == 'open') {
                updateMenuState('close');
              } else {
                updateMenuState('open');
              }
            },
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(
                  Icons.account_circle_outlined,
                  size: 30,
                  color: Color.fromRGBO(210, 184, 149, 1),
                )
                // SvgPicture.asset(
                //   'assets/images/avatar.svg',
                //   width: 30,
                //   height: 30,
                // ),
                ),
          )
        ],
      ),
    );
  }
}

class Spot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: MediaQuery.of(context).size.width * 0.5 - 32,
      child: GestureDetector(
        onTap: () {
          print(ModalRoute.of(context).settings.name);
          if (ModalRoute.of(context).settings.name != "/trainers_list") {
            Navigator.pushReplacementNamed(context, '/trainers_list');
          }
        },
        child: Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
                color: Color(0XFFE19F0C),
                border: Border.all(
                    color: Color.fromRGBO(244, 243, 246, 1), width: 4),
                // color: Colors.white,
                shape: BoxShape.circle),
            child: Center(
              child: SvgPicture.asset(
                'assets/images/spot.svg',
                width: 26,
                height: 26,
              ),
            )),
      ),
    );
  }
}

class SpotBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        left: MediaQuery.of(context).size.width * 0.5 - 42,
        child: Container(
          height: 56,
          color: Color.fromRGBO(244, 243, 246, 1),
          child: Row(
            children: [
              Container(
                width: 10,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(20)),
                    gradient: LinearGradient(
                      begin: Alignment(0, 1.0),
                      end: Alignment(0, -1.0),
                      colors: [
                        Color.fromRGBO(216, 150, 20, 1),
                        Color.fromRGBO(251, 200, 78, 1)
                      ],
                    )),
              ),
              Container(
                // margin: EdgeInsets.only(
                //     left: 4, right: 4),
                width: 64,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment(0, 1.0),
                  end: Alignment(0, -1.0),
                  colors: [
                    Color.fromRGBO(216, 150, 20, 1),
                    Color.fromRGBO(251, 200, 78, 1)
                  ],
                )),
              ),
              Container(
                width: 10,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(20)),
                    gradient: LinearGradient(
                      begin: Alignment(0, 1.0),
                      end: Alignment(0, -1.0),
                      colors: [
                        Color.fromRGBO(216, 150, 20, 1),
                        Color.fromRGBO(251, 200, 78, 1)
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}
