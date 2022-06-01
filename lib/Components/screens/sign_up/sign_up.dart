import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:spotter/Components/screens/layout/Layout.dart';
import 'package:spotter/Components/screens/sign_up/verification_code.dart';
import 'package:spotter/Components/screens/web_view_container.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/core/http.dart';
// import 'package:device_info/device_info.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:provider/provider.dart';
import 'package:spotter/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotter/core/storage.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

class SignUp extends StatefulWidget {
  @override
  ComponentState createState() => ComponentState();
}

class ComponentState extends State {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool agreed = false;
  bool obSecure = true;
  bool obSecureC = true;
  String registrationError = "";
  var _tabTextIndexSelected = 0;
  final SecureStorage storage = SecureStorage();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Layout(LayoutBuilder(builder: (context, constraint) {
      return SingleChildScrollView(
        child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: registerForm()),
      );
    }));
  }

  Widget registerForm() => Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 24,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.zero,
              child:
              FlutterToggleTab(
                borderRadius: 10,
                width: 70,
                height: 40,
                selectedIndex: _tabTextIndexSelected,
                selectedBackgroundColors: [Color.fromRGBO(210, 184, 149, 1), Color.fromRGBO(210, 184, 149, 1)],
                selectedTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,),
                unSelectedBackgroundColors: [Color.fromRGBO(210, 184, 149, 0.2), Color.fromRGBO(210, 184, 149, 0.2)],
                unSelectedTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                labels: ["Client", "Trainer", "Gym Owner"],
                selectedLabelIndex: (index) {
                  setState(() {
                    _tabTextIndexSelected = index;
                  });
                },
                isScroll: false,
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(0,10,0,20),
                padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromRGBO(210, 184, 149, 1)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  maxLines: 1,
                  controller: username,
                  style: TextStyle(color: Color.fromRGBO(210, 184, 149, 1)),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 0.0),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Container(
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(color: Color.fromRGBO(210, 184, 149, 1))),
                      ),
                      child: Icon(
                        Icons.perm_identity,
                        color: Color.fromRGBO(210, 184, 149, 1),
                        size: MediaQuery.of(context).size.width * 0.06,
                      ),
                    ),
                    labelText: "Full Name",
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(210, 184, 149, 1),
                      fontSize: MediaQuery.of(context).size.width * 0.042,
                    ),
                    border: InputBorder.none,
                    hintMaxLines: 2,
                    hintText: 'First & Last Name',
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(210, 184, 149, 0.5),
                      fontSize: MediaQuery.of(context).size.width * 0.042,
                    ),
                  ),
                )
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 20.0),
                padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromRGBO(210, 184, 149, 1)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  maxLines: 1,
                  controller: email,
                  style: TextStyle(color: Color.fromRGBO(210, 184, 149, 1)),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 0.0),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Container(
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(color: Color.fromRGBO(210, 184, 149, 1))),
                      ),
                      child: Icon(
                        Icons.mail_outline,
                        color: Color.fromRGBO(210, 184, 149, 1),
                        size: MediaQuery.of(context).size.width * 0.06,
                      ),
                    ),
                    labelText: "Email",
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(210, 184, 149, 1),
                      fontSize: MediaQuery.of(context).size.width * 0.042,
                    ),
                    border: InputBorder.none,
                    hintMaxLines: 2,
                    hintText: 'email@email.com',
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(210, 184, 149, 0.5),
                      fontSize: MediaQuery.of(context).size.width * 0.042,
                    ),
                  ),
                )
            ),
            Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromRGBO(210, 184, 149, 1)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  maxLines: 1,
                  controller: password,
                  obscureText: obSecure,
                  style: TextStyle(color: Color.fromRGBO(210, 184, 149, 1)),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 0.0),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Container(
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(color: Color.fromRGBO(210, 184, 149, 1))),
                      ),
                      child: Icon(
                        Icons.lock_outline,
                        color: Color.fromRGBO(210, 184, 149, 1),
                        size: MediaQuery.of(context).size.width * 0.06,
                        ),
                    ),
                    suffixIcon: Container(
                      margin: EdgeInsets.only(left: 8),
                      child:  GestureDetector(
                        child: Icon(
                          Icons.visibility,
                          color: Color.fromRGBO(210, 184, 149, 1),
                          size: MediaQuery.of(context).size.width * 0.06,
                        ),
                        onTap: () => {
                          setState(() {
                            obSecure = !obSecure;
                          })
                        },
                      ),
                    ),
                    labelText: "Password",
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(210, 184, 149, 1),
                      fontSize: MediaQuery.of(context).size.width * 0.042,
                    ),
                    border: InputBorder.none,
                    hintMaxLines: 2,
                    hintText: 'password',
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(210, 184, 149, 0.5),
                      fontSize: MediaQuery.of(context).size.width * 0.042,
                    ),
                  ),
                )
            ),
            Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0, bottom: 0.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromRGBO(210, 184, 149, 1)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  maxLines: 1,
                  controller: confirmPassword,
                  obscureText: obSecureC,
                  style: TextStyle(color: Color.fromRGBO(210, 184, 149, 1)),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 0.0),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Container(
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(color: Color.fromRGBO(210, 184, 149, 1))),
                      ),
                      child: Icon(
                        Icons.lock_outline,
                        color: Color.fromRGBO(210, 184, 149, 1),
                        size: MediaQuery.of(context).size.width * 0.06,
                      ),
                    ),
                    suffixIcon: Container(
                      margin: EdgeInsets.only(left: 8),
                      child:  GestureDetector(
                        child: Icon(
                          Icons.visibility,
                          color: Color.fromRGBO(210, 184, 149, 1),
                          size: MediaQuery.of(context).size.width * 0.06,
                        ),
                        onTap: () => {
                          setState(() {
                            obSecureC = !obSecureC;
                          })
                        },
                      ),
                    ),
                    labelText: "Confirm Password",
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(210, 184, 149, 1),
                      fontSize: MediaQuery.of(context).size.width * 0.042,
                    ),
                    border: InputBorder.none,
                    hintMaxLines: 2,
                    hintText: 'Confirm password',
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(210, 184, 149, 0.5),
                      fontSize: MediaQuery.of(context).size.width * 0.042,
                    ),
                  ),
                )
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0.0, 0, 10.0),
              child:
              Text('$registrationError',
                  textAlign: TextAlign.end,
                  style:
                  TextStyle(fontSize: 12, color: Colors.red)),
            ),
            Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                child:
                ElevatedButton(
                    child: Text(
                        "SIGN UP".toUpperCase(),
                        style: TextStyle(fontSize: 14)
                    ),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(top: 20.0, bottom: 20.0)),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(210, 184, 149, 1)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )
                        )
                    ),
                    onPressed: () => {
                      _checkValid(context)
                    }
                )
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text('OR',
                  textAlign: TextAlign.center, style: TextStyle(color: Color.fromRGBO(210, 184, 149, 1))),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.white,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  "assets/images/facebook-logo.svg",
                                )
                            ),
                          ],
                        )
                    ),
                    Expanded(
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.white,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  "assets/images/google-logo.svg",
                                )
                            ),
                          ],
                        )
                    ),
                  ],
                )
            ),
            RichText(
              text: TextSpan(
                  style: TextStyle(color: Color.fromRGBO(210, 184, 149, 1)),
                  children: [
                    TextSpan(
                        text: 'Login',
                        style: TextStyle(decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pop(context))
                  ]),
            ),
          ],
        ),
      );

  void _checkValid(BuildContext context) {
    if (username.text.isEmpty || email.text.isEmpty || password.text.isEmpty || confirmPassword.text.isEmpty)
      setState(() {
        registrationError = 'Please fill all the fields';
      });
    else
    {
      if(!username.text.contains(" "))
        setState(() {
          registrationError = 'Please input the firstname and lastname';
        });
      else
        {
          if(password.text.length < 8)
            setState(() {
              registrationError = 'Password should be more than 8 length';
            });
          else {
            if (password.text.compareTo(confirmPassword.text) != 0)
              setState(() {
                registrationError = 'Password does not match';
              });
            else
              _createAccount(context);
          }
        }
    }
  }
  void _createAccount(BuildContext context) {
    setState(() {
      registrationError = '';
    });
    _create();
  }

  void _savePersona(String persona) async{
    await storage.savePersona(persona);
  }

  void _create() async {
    switch (_tabTextIndexSelected){
      case 0:
        _savePersona("user");
        Provider.of<AppState>(context, listen: false)
            .setUserPersona("user");
        break;
      case 1:
        _savePersona("trainer");
        Provider.of<AppState>(context, listen: false)
            .setUserPersona("trainer");
        break;
      case 1:
        _savePersona("owner");
        Provider.of<AppState>(context, listen: false)
            .setUserPersona("owner");
        break;
    }
    final apiCall = HttpClient(localApiUrls.user);
    apiCall.headers['content-type'] = 'application/json';
    try {
      Provider.of<AppState>(context, listen: false).enableSpinner();
      final result = await apiCall.post(
          '/api/v1/users/create?firstName=${username.text.split(" ")[0]}&lastName=${username.text.split(" ")[1]}&password=${password.text}&emailAddress=${email.text}',
          {});
      print(result);
      Provider.of<AppState>(context, listen: false).disableSpinner();
      if (result['statusCode'] == 200) {
        Provider.of<AppState>(context, listen: false).disableSpinner();

        final snackBar = SnackBar(
            duration: Duration(seconds: 5),
            content: Text(
                'Email verified. Login now !!')); // Find the ScaffoldMessenger in the widget tree
        // and use it to show a SnackBar.
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    VerficationCode(email.text)));
      }
    } catch (e) {
      Provider.of<AppState>(context, listen: false).disableSpinner();
      print("error");
      print(e);
      setState(() {
        registrationError = e.message;
      });
    }
  }


  Widget _register() => GestureDetector(
        onTap: () async {
          if (_formKey.currentState.validate() && agreed) {
            setState(() {
              registrationError = "";
            });
            final apiCall = HttpClient(productionApiUrls.user);
            apiCall.headers['content-type'] = 'application/json';
            try {
              Provider.of<AppState>(context, listen: false).enableSpinner();
              final result = await apiCall.post(
                  '/api/v1/users/create?firstName=${username.text}&emailAddress=${email.text}&phone=${phone.text}&password=${password.text}&role=${Provider.of<AppState>(context, listen: false).userPersona}',
                  {});
              print(result);
              if (result['statusCode'] == 200) {
                Provider.of<AppState>(context, listen: false).disableSpinner();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            VerficationCode(email.text)));
              }
            } catch (e) {
              Provider.of<AppState>(context, listen: false).disableSpinner();
              print("error");
              print(e);
              setState(() {
                registrationError = e.message;
              });
            }
          }
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(251, 200, 78, 1),
                Color.fromRGBO(216, 150, 20, 1)
              ]),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Text(
              'Register Now',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )),
      );

  void _handleURLButtonPress() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WebViewContainer('assets/webview/terms.html')));
  }
}
