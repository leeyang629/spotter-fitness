import 'package:flutter/material.dart';

Widget dashboardCard(
    {Widget child,
    Color color = Colors.white,
    double height = 146,
    double width,
    double padding = 12,
    Gradient gradient}) {
  return Container(
    margin: EdgeInsets.all(8),
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
        gradient: gradient,
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 20, offset: Offset(0, 10))
        ]),
    height: height,
    width: width,
    child: child,
  );
}
