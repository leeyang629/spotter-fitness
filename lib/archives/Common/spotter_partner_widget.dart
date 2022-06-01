import 'package:flutter/material.dart';

class SpotterPartnerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Image(
              image: Image.asset('assets/images/SpotIcon_Button_R2.png').image),
          Text('Spotter Partner')
        ],
      ),
    );
  }
}
