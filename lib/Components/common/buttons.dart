import 'package:flutter/material.dart';

Widget roundClickButton(Color color, String text, Function clickHandler) =>
    ElevatedButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(16)),
          backgroundColor: MaterialStateProperty.all<Color>(color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ))),
      child: Text(text, style: TextStyle(fontSize: 14)),
      onPressed: clickHandler,
    );

Widget backButton(Function backHandler) {
  return SizedBox(
      width: 40,
      height: 40,
      child: TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[200]),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(40.0),
              ),
            )),
          ),
          onPressed: () {
            backHandler();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          )));
}
