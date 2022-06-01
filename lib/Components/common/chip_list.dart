import 'package:flutter/material.dart';

List<Widget> chipList(String heading, List<String> values) {
  return [
    Padding(
      padding: EdgeInsets.fromLTRB(12, 20, 8, 12),
      child: Text(heading,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          )),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
          spacing: 10,
          runSpacing: 5,
          // direction: Axis.horizontal,
          children: values.map((value) {
            return Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(234, 234, 235, 1),
              ),
              child: Text(value,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Color.fromRGBO(54, 53, 52, 1))),
            );
          }).toList()),
    )
  ];
}
