import 'package:flutter/material.dart';
import 'package:spotter/Components/screens/login/login.dart';

class UserLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Login(),
      ],
    );
  }
}
