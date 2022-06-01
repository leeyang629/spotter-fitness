import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/Components/screens/layout/Layout.dart';
import 'package:spotter/Components/screens/login/presentation.dart';
import 'package:spotter/Components/screens/login/utils.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:spotter/core/storage.dart';
import 'package:spotter/Components/common/buttons.dart';
import 'package:spotter/utils/userDataLoad.dart';
import 'package:spotter/utils/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

class Login extends StatefulWidget {
  final bool withHeading;
  final String heading;
  Login({this.withHeading = false, this.heading = ""});
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  String loginError = "";
  String emailError = "";
  bool obSecure = true;
  final SecureStorage storage = SecureStorage();
  LoginUtil login;
  var _tabTextIndexSelected = 0;
  List<bool> _selections = List.generate(3, (_)=> false);

  @override
  void initState() {
    super.initState();
    this.login = LoginUtil();
  }

  void _handleGoogleSignIn() async {
    try {
      Provider.of<AppState>(context, listen: false).enableSpinner();
      final result = await this.login.handleGoogleSignIn(
          Provider.of<AppState>(context, listen: false).userPersona);
      print("result");
      print(result);
      if (result['statusCode'] == 200) {
        if (result != null &&
            result["authToken"] != '' &&
            result['deviceId'] != '' &&
            result['user']['id'] != '' &&
            result['user']['firstName'] != '') {
          await saveUserDetails(
              result['authToken'] ?? "",
              result['user']['id'] ?? "",
              result['deviceId'] ?? "",
              result['user']['firstName'] ?? "",
              result['user']['imageURL'] ?? "",
              result['user']['emailAddress'] ?? "",
              radius: isNotEmpty(result['user']['settings'])
                  ? double.parse(
                      (result['user']['settings']["radius"] ?? 5).toString())
                  : 5.0,
              notifications: result['user']['settings'] != null
                  ? result['user']['settings']["notifications"] ?? true
                  : true);
        }
        await getUserData(context);
        Provider.of<AppState>(context, listen: false).disableSpinner();
      }
    } catch (e) {
      Provider.of<AppState>(context, listen: false).disableSpinner();
      print("error");
      print(Provider.of<AppState>(context, listen: false).userPersona);
      print(e);
      // setState(() {
      //   loginError = e;
      // });
    }
  }

  void onFbSignIn() async {
    try {
      Provider.of<AppState>(context, listen: false).enableSpinner();
      final result = await this.login.onFbSignIn(
          Provider.of<AppState>(context, listen: false).userPersona);
      print(result);
      if (result['statusCode'] == 200) {
        Provider.of<AppState>(context, listen: false).disableSpinner();
        if (result["authToken"] != '' &&
            result['deviceId'] != '' &&
            result['user']['id'] != '' &&
            result['user']['firstName'] != '') {
          await saveUserDetails(
              result['authToken'] ?? "",
              result['user']['id'] ?? "",
              result['deviceId'] ?? "",
              result['user']['firstName'] ?? "",
              result['user']['imageURL'] ?? "",
              result['user']['emailAddress'] ?? "",
              radius: result['user']['settings'] != null
                  ? double.parse(
                      (result['user']['settings']["radius"] ?? 5).toString())
                  : 5.0,
              notifications: result['user']['settings'] != null
                  ? result['user']['settings']["notifications"] ?? true
                  : true);
        }
        await getUserData(context);
      }
    } catch (e) {
      Provider.of<AppState>(context, listen: false).disableSpinner();
      print("error");
      print(e);
      setState(() {
        loginError = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                            margin: EdgeInsets.only(top: 10.0),
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
                                hintText: 'email@gmail.com',
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(210, 184, 149, 0.5),
                                  fontSize: MediaQuery.of(context).size.width * 0.042,
                                ),
                              ),
                            )
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                          child:
                            Text('$emailError',
                                textAlign: TextAlign.left,
                                style:
                                TextStyle(fontSize: 12, color: Colors.red)),
                        ),
                        Container(
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
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0.0),
                          child:
                          Text('$loginError',
                              textAlign: TextAlign.left,
                              style:
                              TextStyle(fontSize: 12, color: Colors.red)),
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 0.0, 0, 0),
                            child:
                            RichText(
                              textHeightBehavior: TextHeightBehavior(),
                              textAlign: TextAlign.end,
                              text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color.fromRGBO(210, 184, 149, 1)),
                                      text: 'Forgot password?',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Navigator.pushNamed(context, '/signup'),
                                    ),
                                  ]),
                            )
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                          child:
                          ElevatedButton(
                              child: Text(
                                  "LOGIN".toUpperCase(),
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
                              onPressed: () => _checkValid(context),
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Text('OR',
                              textAlign: TextAlign.center, style: TextStyle(color: Color.fromRGBO(210, 184, 149, 1))),
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
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
                                            child:  GestureDetector(
                                              child:SvgPicture.asset(
                                                "assets/images/google-logo.svg",
                                              ),
                                              onTap: () => {
                                                _handleGoogleSignIn()
                                              },
                                            ),
                                        ),
                                      ],
                                    )
                                ),
                              ],
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 30.0, 0, 0),
                            child:
                            RichText(
                              textHeightBehavior: TextHeightBehavior(),
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color.fromRGBO(210, 184, 149, 1)),
                                      text: 'Sign up',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Navigator.pushNamed(context, '/signup'),
                                    ),
                                  ]),
                            )
                        ),
                      ],
                    ))));
      }),
    );
  }
  void _savePersona(String persona) async{
    await storage.savePersona(persona);
  }

  void _checkValid(BuildContext context) {
    // bool emailValid = !RegExp(
    //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(username.text);
    if (username.text.isEmpty)
      setState(() {
        emailError = 'Please input the email';
      });
    else
        setState(() {
          emailError = '';
        });
    if (password.text.isEmpty)
      setState(() {
        loginError = 'Please input the password';
      });
    else
      setState(() {
        loginError = '';
      });
    if(username.text.isNotEmpty && password.text.isNotEmpty)
      _signIn();
  }

  void _signIn() async {
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
    try {
      Provider.of<AppState>(context, listen: false).enableSpinner();
      final result = await this.login.signIn(username.text, password.text);
      print(result);
      if (result['statusCode'] == 200) {
        // loginState.userToken = result['authToken'];
        Provider.of<AppState>(context, listen: false).disableSpinner();
        if (result["authToken"] != '' &&
            result['deviceId'] != '' &&
            result['user']['id'] != '' &&
            result['user']['firstName'] != '') {
          await saveUserDetails(
              result['authToken'] ?? "",
              result['user']['id'] ?? "",
              result['deviceId'] ?? "",
              result['user']['firstName'] ?? "",
              result['user']['imageURL'] ?? "",
              result['user']['emailAddress'] ?? "",
              radius: result['user']['settings'] != null
                  ? double.parse(
                      (result['user']['settings']["radius"] ?? 5).toString())
                  : 5.0,
              notifications: result['user']['settings'] != null
                  ? result['user']['settings']["notifications"] ?? true
                  : true);
        }
        await getUserData(context);
      }
      else
      {
        Provider.of<AppState>(context, listen: false).disableSpinner();
        setState(() {
          loginError = "Something went wrong. Try again";
        });
      }
    } catch (e) {
      Provider.of<AppState>(context, listen: false).disableSpinner();
      // print("error");
      // print(e);
      setState(() {
        loginError = e.toString().replaceAll("Exception: ", "");
      });
    }
  }

  saveUserDetails(String authToken, String permalink, String deviceId,
      String username, String imgUrl, String email,
      {double radius, bool notifications}) async {
    await storage.saveUserToken(authToken);
    await storage.savePermalink(permalink);
    await storage.saveDeviceId(deviceId);
    await storage.saveRadius((radius ?? 5.0).toString());
    await storage.saveNotifications(notifications.toString());
    Provider.of<AppState>(context, listen: false).setEmailId(email);
    print(await storage.getUserToken());
    print(await storage.getPermalink());
    print(await storage.getDeviceId());
  }
}
