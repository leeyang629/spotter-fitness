import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckoutPage extends StatefulWidget {
  final String sessionId;

  const CheckoutPage({Key key, this.sessionId}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: WebView(
          initialUrl: initialUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) => _controller = controller,
          onPageFinished: (String url) {
            //<---- add this
            if (url == initialUrl) {
              _redirectToStripe();
            }
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://success.com')) {
              Navigator.of(context).pop('success'); // <-- Handle success case
            } else if (request.url.startsWith('https://cancel.com')) {
              Navigator.of(context).pop('cancel'); // <-- Handle cancel case
            }
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }

  void _redirectToStripe() {
    //<--- prepare the JS in a normal string
    final redirectToCheckoutJs = '''
      var stripe = Stripe(\'pk_test_51K4sDJLocyrCH2mHruEZ5cEoT51kxXEQ1I11hshg6R6Dm39g4NCu0K5yA9VCHGcmoUcO5XuUyINL5RcbcoYV0Yyu00ytcIsSyg\');
          
      stripe.redirectToCheckout({
        sessionId: '${widget.sessionId}'
      }).then(function (result) {
        result.error.message = 'Error'
      });
      123;
      ''';
    _controller.evaluateJavascript(
        redirectToCheckoutJs); //<--- call the JS function on controller
  }

  String get initialUrl =>
      'data:text/html;base64,${base64Encode(Utf8Encoder().convert(kStripeHtmlPage))}';
}

const kStripeHtmlPage = '''
<!DOCTYPE html>
<html>

<head>
    <title>Stripe checkout</title>
    <script src="https://js.stripe.com/v3/"></script>
</head>
<style>
.container{
    display: flex;
  height: 100vh;
  justify-content: center;
  align-items: center;
}
.loader {
  border: 16px solid #f3f3f3; /* Light grey */
  border-top: 16px solid #3498db; /* Blue */
  border-radius: 50%;
  width: 120px;
  height: 120px;
  animation: spin 2s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style>
<body>
<div class="container">
  <div class="loader"></div>
</div>
</body>

</html>
''';
