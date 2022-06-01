import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spotter/Components/common/LoadingIndicator.dart';
import 'package:spotter/archives/Common/Card/places_information.dart';
import 'package:spotter/archives/Utils/Converter.dart';
import 'package:spotter/archives/models/Gym.dart';
import 'package:spotter/archives/Location.dart';

class ListGymsPage extends StatefulWidget {
  @override
  _ListPageState createState() {
    return new _ListPageState();
  }
}

class _ListPageState extends State<ListGymsPage> {
  // List _items = [];
  List<Gym> _gyms;

  @override
  void initState() {
    super.initState();
    loadJSON();
  }

  Future<void> loadJSON() async {
    LatLng coordinates = await Location().getCurrentLocation();
    String url =
        "https://api.spotterfitness.org/api/v1/places/nearby_search?lat=" +
            coordinates.latitude.toString() +
            "&long=" +
            coordinates.longitude.toString() +
            "&type=gym&radius=2300";
    print("Request URL: " + url);
    Map<String, dynamic> response = await Converter.loadJSONFromURL(url);
    List<Gym> gyms = Converter.jsonToGymsList(response);
    setState(() {
      _gyms = gyms;
    });
  }

  Future<bool> isGymsPresent() async {
    if (_gyms.isEmpty) {
      return null;
    }
    return false;
  }

  // static String dummyLocation = "assets/dummy/json/list_gyms.json";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: isGymsPresent(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                body: ListView.builder(
                    // scrollDirection: Axis.vertical,
                    itemCount: _gyms.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                        child: PlacesInformation(
                          gym: _gyms[index],
                        ),
                      );
                    }));
          } else {
            return LoadingIndicator();
          }
        });

// Widget placesList() {}
  }
}
