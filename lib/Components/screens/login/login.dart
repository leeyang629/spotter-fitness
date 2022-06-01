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
  final SecureStorage storage = SecureStorage();
  LoginUtil login;

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
                    padding: const EdgeInsets.only(top: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (widget.withHeading)
                          Text(
                            widget.heading,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(247, 165, 4, 1),
                                fontStyle: FontStyle.italic,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        Container(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textField("Email Address", username, (value) {
                              setState(() {
                                loginError = "";
                              });
                            }),
                            Padding(padding: EdgeInsets.only(top: 20.0)),
                            textField("Password", password, (value) {
                              setState(() {
                                loginError = "";
                              });
                            }),
                            Text(loginError,
                                textAlign: TextAlign.right,
                                style:
                                    TextStyle(fontSize: 12, color: Colors.red))
                          ],
                        )),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                          child: roundClickButton(
                              Color.fromRGBO(247, 165, 4, 1), "Sign In", () {
                            _signIn();
                          }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Text('OR',
                              textAlign: TextAlign.center, style: TextStyle()),
                        ),
                        roundClickButton(Color.fromRGBO(54, 127, 192, 1),
                            "Login With Facebook", onFbSignIn),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10.0, 0, 10),
                          child: roundClickButton(
                              Color.fromRGBO(221, 75, 57, 1),
                              "Login with Google", () {
                            _handleGoogleSignIn();
                          }),
                        ),
                        signUpLink(context),
                        if (Provider.of<AppState>(context).userPersona !=
                            "user")
                          RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: " <- Login as Normal User",
                                  style: TextStyle(
                                      color: Color.fromRGBO(175, 136, 8, 1),
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      await storage.savePersona("user");
                                      Provider.of<AppState>(context,
                                              listen: false)
                                          .setUserPersona("user");
                                      Navigator.pushReplacementNamed(
                                          context, '/login');
                                    })),
                        if (Provider.of<AppState>(context).userPersona ==
                            "user")
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                Flexible(
                                    fit: FlexFit.tight,
                                    child: roundClickButton(
                                        Color.fromRGBO(221, 75, 57, 1),
                                        "Trainer Portal", () async {
                                      await storage.savePersona("trainer");
                                      Provider.of<AppState>(context,
                                              listen: false)
                                          .setUserPersona("trainer");
                                      Navigator.pushReplacementNamed(
                                          context, '/trainer_login');
                                    })),
                                SizedBox(
                                  width: 20,
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: roundClickButton(
                                      Color.fromRGBO(16, 33, 84, 1),
                                      "Gym Owner Portal", () async {
                                    await storage.savePersona("owner");
                                    Provider.of<AppState>(context,
                                            listen: false)
                                        .setUserPersona("owner");
                                    Navigator.pushReplacementNamed(
                                        context, '/gym_login');
                                  }),
                                )
                              ],
                            ),
                          ),
                        termsAndPolicy(context)
                      ],
                    ))));
      }),
    );
  }

  void _signIn() async {
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
    } catch (e) {
      Provider.of<AppState>(context, listen: false).disableSpinner();
      print("error");
      print(e);
      setState(() {
        loginError = e;
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
