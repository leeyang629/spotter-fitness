import 'package:flutter/material.dart';
import 'package:spotter/Components/screens/login/login.dart';

class GymLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Login(
      withHeading: true,
      heading: "Gym Owner Portal",
    );
  }
}
