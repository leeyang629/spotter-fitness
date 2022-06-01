import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    // return Scaffold(
    //   body: Container(
    //     height: 200,
    //     width: double.infinity,
    //     decoration: BoxDecoration(
    //       image: DecorationImage(
    //         image: AssetImage("assets/images/verify_background.png"),
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //     child: null /* add child content here */,
    //   ),
    // );
    return LayoutWithUser(
      Center(
        child: Stack(children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/verify_background.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(top: 40.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.only(left: 10.0)),
                    Text(
                      "X",
                      style: TextStyle(
                          color: Colors.transparent,
                          fontSize: 34,
                          decoration: TextDecoration.none),
                    ),
                    Expanded(child:
                      Text(
                        "SPOTTER",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            decoration: TextDecoration.none),
                      )
                    ),
                    Text(
                      "X",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          decoration: TextDecoration.none),
                    ),
                    Padding(padding: EdgeInsets.only(right: 10.0))
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 30.0)),
                Text(
                  "Verification Code sent to Email",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      decoration: TextDecoration.none),
                ),
                Padding(padding: EdgeInsets.only(top: 10.0)),
                Text(
                  "Please verify your account",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.none),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     _getTextField(value0, first: true),
                //     _getTextField(value1),
                //     _getTextField(value2),
                //     _getTextField(value3),
                //     _getTextField(value4),
                //     _getTextField(value5, last: true)
                //   ],
                // ),

                Padding(
                    padding: EdgeInsets.fromLTRB(25.0, 30.0, 25.0, 30.0),
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      onChanged: (text) {
                        if (text.length == 6)
                        {
                          final persona = Provider.of<AppState>(context, listen: false).userPersona;
                          if (persona == "user")
                            Navigator.pushNamed(context,
                                '/register_user_profile');
                          else
                            Navigator.pushNamed(context,
                                '/register_trainer_profile');
                        }
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color.fromRGBO(255, 255, 255, 0.3),
                        hintMaxLines: 1,
                        hintText: 'code',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.042,
                        ),
                      ),
                    ),
                ),
                Text(
                  "Send code again (10s)",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.none),
                ),
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
