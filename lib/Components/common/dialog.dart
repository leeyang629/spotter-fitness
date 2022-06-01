import 'package:flutter/material.dart';

errorDialog(BuildContext context, Function refreshScreen, String errorText) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Network Error"),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          actions: [TextButton(onPressed: refreshScreen, child: Text("Retry"))],
          content: Text(errorText,
              textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
        );
      });
}

popupDialog(
    BuildContext context, String title, String content, List<Widget> actions,
    {bool barrierDismissible = true}) async {
  await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(title), content: Text(content), actions: actions
            //  [
            //   TextButton(
            //     child: Text("Back"),
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //   ),
            //   TextButton(
            //     child: Text("Yes"),
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //   )
            // ],
            );
      });
}
