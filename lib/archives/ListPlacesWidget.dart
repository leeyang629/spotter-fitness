import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListPlacesWidget extends StatelessWidget {
  List places = [];

  ListPlacesWidget(List list) {
    this.places = places;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: checkIfDataIsEmpty(places),
    );
  }

  Widget checkIfDataIsEmpty(List data) {
    if (data.isEmpty) {
      return Container(child: Text("There is no Data"));
    }
    return Container(
      child: Text("Data is Present"),
    );
  }
}
