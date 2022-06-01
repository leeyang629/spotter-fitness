import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: const SpinKitRing(
        color: Color.fromRGBO(251, 200, 78, 1),
        size: 50.0,
        lineWidth: 5,
      ),
    );
  }
}
