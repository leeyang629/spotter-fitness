import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/archives/LocationModel.dart';

// ignore: must_be_immutable
class Mapper extends StatelessWidget {
  LocationModel mapModel = new LocationModel();

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationModel>(builder: (context, mapModel, child) {
      return mapModel.initGoogleMap();
    });
  }

  // FutureBuilder<GoogleMap> _getInitMap(context) {
  //   return Provider.of<LocationModel>(context, listen: false).initGoogleMap();
  // }
}
