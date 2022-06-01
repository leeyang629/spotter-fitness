import 'package:spotter/Components/screens/Home/home.dart';

import 'package:flutter/material.dart';
import 'package:spotter/routes.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: routeConfiguration(context),
      routes: {
        "/": (context) => Home(),
      },
    );
  }
}
