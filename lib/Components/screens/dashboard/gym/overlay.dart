import 'package:flutter/material.dart';

OverlayEntry createOverlayEntry(
    TapDownDetails details, BuildContext context, Function clickHandler) {
  RenderBox renderBox = context.findRenderObject();
  var size = renderBox.size;
  var offset = details.globalPosition;

  return OverlayEntry(
      builder: (context) => Positioned(
            left: offset.dx + 200 >= size.width ? offset.dx - 200 : offset.dx,
            top: offset.dy + 200 >= size.height
                ? (offset.dy - 10) - 200
                : (offset.dy - 10),
            width: 200,
            child: Material(
              elevation: 4.0,
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: <Widget>[
                  ListTile(
                    title: Text('Last day'),
                    onTap: () {
                      print('day');
                      clickHandler('day');
                    },
                  ),
                  ListTile(
                    title: Text('Last Month'),
                    onTap: () {
                      print('month');
                      clickHandler('month');
                    },
                  )
                ],
              ),
            ),
          ));
}
