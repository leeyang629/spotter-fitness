import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spotter/Components/common/map_asbtract.dart';
import 'package:spotter/Components/screens/map/map_search.dart';
import 'package:spotter/utils/permissions.dart';

class PositionClass {
  final Map<String, dynamic> location;
  PositionClass(this.location);
}

class SetLocation extends StatefulWidget {
  @override
  State<SetLocation> createState() => MapState();
}

class MapState extends State<SetLocation> {
  GoogleMapController mapController;
  Position currentLocation;
  final Map<String, Marker> _markers = {};
  bool hasSearchFocus = false;
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    Position location = await getPermission();
    print(location);
    if (mounted && _markers["current"] == null) {
      setState(() {
        currentLocation = Position(
            latitude: location.latitude, longitude: location.longitude);
      });
      addMarker(location, -1, "current");
      panToSelectedMarker(location.latitude, location.longitude);
    }
  }

  onMapTap(LatLng location) {
    final Position current =
        Position(longitude: location.longitude, latitude: location.latitude);
    setState(() {
      currentLocation = current;
    });
    addMarker(current, -1, "current");
  }

  addMarker(Position location, int index, String key) {
    print("tapped Location");
    print(location);
    if (location != null) {
      setState(() {
        _markers[key] = Marker(
            onTap: () {},
            markerId: MarkerId("current"),
            icon: BitmapDescriptor.defaultMarker,
            position: LatLng(location.latitude, location.longitude));
      });
    }
  }

  setMapController(GoogleMapController controller) {
    if (mounted) {
      setState(() {
        mapController = controller;
      });
    }
  }

  panToSelectedMarker(double lat, double long) {
    // mapController.animateCamera(CameraUpdate.newLatLng(new LatLng(lat, long)));
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 14.4746,
    )));
  }

  Future<bool> _backButtonPressed() async {
    if (hasSearchFocus) {
      setSearchFocus(false);
      FocusManager.instance.primaryFocus.unfocus();
      return Future.delayed(Duration(seconds: 0), () {
        return false;
      });
    } else {
      Navigator.pop(context, _markers["current"].position);
      return Future.delayed(Duration(seconds: 0), () {
        return false;
      });
    }
  }

  void setCurrentLocation(Position location) async {
    panToSelectedMarker(location.latitude, location.longitude);
    addMarker(location, -1, 'current');
  }

  void resetCurrentLocation() {
    panToSelectedMarker(currentLocation.latitude, currentLocation.longitude);
    addMarker(currentLocation, -1, 'current');
  }

  setSearchFocus(bool flag) {
    setState(() {
      hasSearchFocus = flag;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, PositionClass>;
    final args = arguments["location"];
    if (args.location["latitude"] != 0 &&
        args.location["longitude"] != 0 &&
        currentLocation == null) {
      final Position current = Position(
          latitude: args.location["latitude"],
          longitude: args.location["longitude"]);
      setCurrentLocation(current);
      setState(() {
        currentLocation = current;
      });
    }
    return Scaffold(
      body: WillPopScope(
          onWillPop: _backButtonPressed,
          child: Stack(children: [
            MapLayer(
              currentLocation: currentLocation,
              markers: _markers,
              onMapTap: onMapTap,
              addMarkers: addMarker,
              mapController: mapController,
              setMapController: setMapController,
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.5 - 24,
              bottom: 16,
              child: TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.fromLTRB(10, 12, 10, 12)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(15, 32, 84, 1))),
                clipBehavior: Clip.hardEdge,
                onPressed: () {
                  Navigator.pop(context, _markers["current"].position);
                },
                child: Text("Done", style: TextStyle(color: Colors.white)),
              ),
            ),
            MapSearch(setCurrentLocation, resetCurrentLocation, hasSearchFocus,
                setSearchFocus)
          ])),
    );
  }
}

class SetLocationWrapper extends StatelessWidget {
  final Function commonChangeHandler;
  final Map<String, double> location;
  SetLocationWrapper(this.commonChangeHandler,
      {this.location = const {"latitude": 0, "longitude": 0}});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: Color.fromRGBO(242, 239, 196, 1)),
          child: Icon(
            Icons.place,
            color: Colors.red,
            size: MediaQuery.of(context).size.width * .75,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.fromLTRB(10, 12, 10, 12)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(15, 32, 84, 1))),
            clipBehavior: Clip.hardEdge,
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/set_location',
                  arguments: {"location": new PositionClass(location)});
              print("result");
              print(result);
              commonChangeHandler(30, result);
            },
            child: Text(
              "Set Location",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900),
            )),
        SizedBox(
          height: 20,
        ),
        if (location["latitude"] != 0 && location["longitude"] != 0)
          Text(
            "Location(lat: ${location["latitude"].toStringAsFixed(2)}, long: ${location["longitude"].toStringAsFixed(2)})",
            textAlign: TextAlign.center,
          )
      ],
    );
  }
}
