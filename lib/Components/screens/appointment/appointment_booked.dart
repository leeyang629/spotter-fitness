import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class AppointmentBooked extends StatefulWidget {
  final String name;
  AppointmentBooked(this.name);
  @override
  ComponentState createState() => ComponentState();
}

class ComponentState extends State<AppointmentBooked>
    with TickerProviderStateMixin {
  int animationProgress = 0;
  Animation _animation;
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 200), () {
      _controller.forward();
    });
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color.fromRGBO(15, 32, 84, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // shape:
              //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              // color: Color.fromRGBO(232, 44, 53, 1),
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(232, 44, 53, 1),
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
                width: MediaQuery.of(context).size.width - 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (BuildContext context, child) =>
                          Transform.rotate(
                        angle: math.pi * (0.1) * (1 - _animation.value),
                        child: Icon(
                          Icons.thumb_up,
                          size: 120,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Text(
                        "Training Session Booked",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Text(
                        "Your session was successfully booked with ${widget.name}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(40, 12, 40, 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 2)),
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
