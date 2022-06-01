import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:spotter/Components/screens/layout/Layout.dart';
import 'package:spotter/Components/screens/login/utils.dart';
import 'package:spotter/Components/screens/sign_up/verification_code.dart';
import 'package:spotter/Components/screens/web_view_container.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/core/http.dart';
// import 'package:device_info/device_info.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:provider/provider.dart';
import 'package:spotter/utils/utils.dart';

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
  String registrationError = "";

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
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                      'Create ${transformPersona(Provider.of<AppState>(context).userPersona)} Account',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Display name for your account';
                      }
                      return null;
                    },
                    controller: username,
                    decoration: InputDecoration(labelText: 'User Name'),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an Email';
                      }
                      return null;
                    },
                    controller: email,
                    decoration: InputDecoration(labelText: 'Email ID'),
                  ),
                  TextFormField(
                    controller: phone,
                    decoration: InputDecoration(labelText: 'Phone No.'),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Password for your account';
                      }
                      return null;
                    },
                    obscureText: true,
                    controller: password,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value != password.text) {
                        return 'Not matching with Password';
                      }
                      return null;
                    },
                    obscureText: true,
                    controller: confirmPassword,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  CheckboxListTile(
                      value: agreed,
                      contentPadding: EdgeInsets.all(0),
                      title: RichText(
                        text: TextSpan(
                            text: "I read and agree to ",
                            style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(176, 182, 186, 1)),
                            children: [
                              TextSpan(
                                  text: "Terms and Conditions",
                                  style: TextStyle(
                                      color: Color.fromRGBO(175, 136, 8, 1),
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      _handleURLButtonPress();
                                    })
                            ]),
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          agreed = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading),
                  SizedBox(
                    height: 24,
                  ),
                  _register(),
                  isNotEmpty(registrationError)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            registrationError,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            RichText(
              text: TextSpan(
                  text: 'Already have an account? ',
                  style: TextStyle(color: Color.fromRGBO(175, 136, 8, 1)),
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

  // void getDeviceInfo() async {
  //   final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  //   print('getdeviceinfo');
  //   try {
  //     if (Platform.isAndroid) {
  //       AndroidDeviceInfo build = await deviceInfoPlugin.androidInfo;
  //       print(build.androidId);
  //       print(build.device);
  //       print(build.version.release);
  //     } else if (Platform.isIOS) {
  //       IosDeviceInfo build = await deviceInfoPlugin.iosInfo;
  //       print(build.identifierForVendor);
  //       print(build.model);
  //       print(build.systemName);
  //       print(build.systemVersion);
  //     }
  //   } on PlatformException {
  //     print('Error: Failed to get platform version.');
  //   }
  // }

  void _handleURLButtonPress() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WebViewContainer('assets/webview/terms.html')));
  }
}
