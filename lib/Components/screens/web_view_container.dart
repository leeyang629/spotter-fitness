import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class WebViewContainer extends StatefulWidget {
  final url;

  WebViewContainer(this.url);

  @override
  createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  // WebViewPlusController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 60, 8, 8),
        child: Column(
          children: [
            Expanded(
                child: WebViewPlus(
              initialUrl: widget.url,
              onWebViewCreated: (controller) {
                // setState(() {
                //   _controller = controller;
                // });
              },
              javascriptMode: JavascriptMode.unrestricted,
            ))
          ],
        ),
      ),
      Positioned(
        left: 10,
        top: 10,
        child: SizedBox(
          width: 40,
          child: TextButton(
              style: ButtonStyle(
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey[200]),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(40.0),
                  ),
                )),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
        ),
      ),
    ])));
  }
}
