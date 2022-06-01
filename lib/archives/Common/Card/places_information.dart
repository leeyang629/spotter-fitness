import 'package:flutter/material.dart';
import 'package:spotter/archives/Common/spotter_partner_widget.dart';
import 'package:spotter/archives/models/Gym.dart';

class PlacesInformation extends StatefulWidget {
  final Widget child;
  final String placeName;
  final String distance;
  final Gym gym;

  PlacesInformation(
      {Key key, this.child, this.placeName, this.distance, this.gym})
      : super(key: key);

  @override
  _PlacesInformationState createState() => _PlacesInformationState();
}

class _PlacesInformationState extends State<PlacesInformation> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/placesInformationPage',
            arguments: {"gym_detail": widget.gym});
      },
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Image.asset("assets/images/la_fitness.png"),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 2, 2, 0),
                child: Column(
                  children: [
                    Text(widget.gym.name),
                    Text(widget.gym.distance.toString() + " Kms")
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SpotterPartnerWidget(),
            )
          ],
        ),
      ),
    );
  }
}
