import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:spotter/Components/screens/web_view_container.dart';

Widget textField(String hinttext, TextEditingController controller,
        Function(String) changeHandler) =>
    TextField(
      obscureText: hinttext == 'Password' ? true : false,
      controller: controller,
      onChanged: changeHandler,
      decoration: InputDecoration(
          hintText: hinttext,
          hintStyle: TextStyle(color: Color.fromRGBO(223, 153, 16, 1)),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(223, 153, 16, 1)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(223, 153, 16, 1)),
          )),
    );

Widget signUpLink(context) => Container(
    padding: EdgeInsets.only(top: 10, bottom: 10),
    child: RichText(
      textHeightBehavior: TextHeightBehavior(),
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'New user? ',
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Color.fromRGBO(175, 136, 8, 1)),
              text: 'Sign up here',
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.pushNamed(context, '/signup'),
            ),
          ]),
    ));

Widget termsAndPolicy(context) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
          textHeightBehavior: TextHeightBehavior(),
          textAlign: TextAlign.center,
          text: TextSpan(
              text: "By creating an account, you agree to our ",
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                    text: "Terms of Service",
                    style: TextStyle(
                        color: Color.fromRGBO(175, 136, 8, 1),
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebViewContainer(
                                    'assets/webview/terms.html')));
                      }),
                TextSpan(
                  text: " and ",
                  style: DefaultTextStyle.of(context).style,
                ),
                TextSpan(
                    text: "Privacy Policy",
                    style: TextStyle(
                        color: Color.fromRGBO(175, 136, 8, 1),
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebViewContainer(
                                    'assets/webview/policy.html')));
                      })
              ])),
    );

Widget UserTypeSelector(context) => Container(
    padding: EdgeInsets.only(top: 10, bottom: 10),
    child: RichText(
      textHeightBehavior: TextHeightBehavior(),
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'New user? ',
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Color.fromRGBO(175, 136, 8, 1)),
              text: 'Sign up here',
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.pushNamed(context, '/signup'),
            ),
          ]),
    ));
