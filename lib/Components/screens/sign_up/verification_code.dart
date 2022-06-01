import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotter/Components/common/SnackBar.dart';
import 'package:spotter/Components/screens/layout/LayoutWithUser.dart';
import 'package:spotter/core/http.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/Components/common/LoadingIndicator.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:provider/provider.dart';

class VerficationCode extends StatefulWidget {
  final String email;
  VerficationCode(this.email);
  @override
  ComponentState createState() => ComponentState();
}

class ComponentState extends State<VerficationCode> {
  TextEditingController value0;
  TextEditingController value1;
  TextEditingController value2;
  TextEditingController value3;
  TextEditingController value4;
  TextEditingController value5;
  FocusNode node0 = FocusNode();
  bool sendVerfication = false;

  @override
  void initState() {
    super.initState();
    initializeWithEmpty();
  }

  initializeWithEmpty() {
    value0 = TextEditingController(text: " ");
    value1 = TextEditingController(text: " ");
    value2 = TextEditingController(text: " ");
    value3 = TextEditingController(text: " ");
    value4 = TextEditingController(text: " ");
    value5 = TextEditingController(text: " ");
  }

  @override
  Widget build(BuildContext context) {
    // FocusScope.of(context).requestFocus(node0);
    return LayoutWithUser(
      Center(
        child: Stack(children: [
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Verification Code sent to Email",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      decoration: TextDecoration.none),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _getTextField(value0, first: true),
                    _getTextField(value1),
                    _getTextField(value2),
                    _getTextField(value3),
                    _getTextField(value4),
                    _getTextField(value5, last: true)
                  ],
                )
              ],
            ),
          ),
          if (sendVerfication) LoadingIndicator()
        ]),
      ),
      noPadding: true,
      bottomMenu: false,
    );
  }

  _getTextField(TextEditingController controller,
      {bool first = false, bool last = false}) {
    return Container(
      margin: EdgeInsets.only(left: 8),
      width: 28,
      child: TextField(
        focusNode: first ? node0 : null,
        textAlign: TextAlign.center,
        enableInteractiveSelection: false,
        autofocus: first,
        showCursor: false,
        controller: controller,
        onChanged: (value) {
          if (value.length == 2) {
            if (last) {
              if (!sendVerfication) {
                sendVerificationRequest();
              }
            } else {
              FocusScope.of(context).nextFocus();
            }
          } else if (value.length == 1) {
            if (first) {
              value0.text = " ";
            } else {
              FocusScope.of(context).previousFocus();
            }
          } else if (value.length == 0) {
            controller.text = " ";
            if (!first) {
              FocusScope.of(context).previousFocus();
            }
          }
        },
        decoration: InputDecoration(
          counterText: "",
        ),
        maxLength: 2,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^ ?\d*'))],
      ),
    );
  }

  Future<void> sendVerificationRequest() async {
    setState(() {
      sendVerfication = true;
    });
    String code = value0.text.trim() +
        value1.text.trim() +
        value2.text.trim() +
        value3.text.trim() +
        value4.text.trim() +
        value5.text.trim();
    try {
      final apiCall = HttpClient(productionApiUrls.user);
      Provider.of<AppState>(context, listen: false).enableSpinner();
      final result = await apiCall.post(
          '/api/v1/users/verify_confirmation_code?verificationCode=$code&emailAddress=${widget.email}',
          {});
      if (result['statusCode'] == 200) {
        Provider.of<AppState>(context, listen: false).disableSpinner();
        Navigator.pushReplacementNamed(context, '/login');
        final snackBar = SnackBar(
            duration: Duration(seconds: 5),
            content: Text(
                'Email verified. Login now !!')); // Find the ScaffoldMessenger in the widget tree
        // and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        Provider.of<AppState>(context, listen: false).disableSpinner();
        resetEverything();
      }
    } catch (e) {
      Provider.of<AppState>(context, listen: false).disableSpinner();
      print('error: $e');
      Provider.of<AppState>(context, listen: false)
          .displaySnackBar("Verification failed. Re-Enter code.");
      resetEverything();
    }
  }

  resetEverything() {
    setState(() {
      sendVerfication = false;
      initializeWithEmpty();
    });
    FocusScope.of(context).requestFocus(node0);
  }
}
