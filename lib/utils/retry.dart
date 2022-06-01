import 'package:flutter/material.dart';

Widget retry(String text, Function retry) => Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(text),
            TextButton(
              onPressed: retry,
              child: Text("Retry!"),
            )
          ],
        ),
      );