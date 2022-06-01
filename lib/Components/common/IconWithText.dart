import 'package:flutter/material.dart';

Widget iconWithFlexibleText(IconData icon, String text) => Row(
      children: [
        Icon(icon),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text),
          ),
        )
      ],
    );

Widget iconWithText(IconData icon, String text) => Row(
      children: [
        Icon(icon),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    );
