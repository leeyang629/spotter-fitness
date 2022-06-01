import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  double latitude;
  double longitude;
  LatLng currentCoordinate;
  LatLng lastKnownCoordinates;

  Future<void> getPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    print("Do we have permission? : " + permission.toString());
    String result = Platform.isAndroid ? "Android" : "iOS";

    // Handle platform specific code

    // if(Platform.isAndroid)
    //   permission.toString();
    //
    // else if(Platform.isIOS)
    //   permission.toString();
    return result;
  }

  // Step b: If we have the permissions then get the current location
  Future<LatLng> getCurrentLocation() async {
    // getPermission().then((result) => {});

    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    Position lastKnownPosition = await Geolocator.getLastKnownPosition();
    this.lastKnownCoordinates =
        LatLng(lastKnownPosition.latitude, lastKnownPosition.longitude);
    print("The Last known position is " + lastKnownPosition.toString());
    this.latitude = currentPosition.latitude;
    this.longitude = currentPosition.longitude;
    this.currentCoordinate = LatLng(latitude, longitude);
    print("The current position is " + currentPosition.toString());
    // var output = {"latitude": this.latitude, "longitude": this.longitude};
    print(this.currentCoordinate);
    if (this.latitude == null || this.longitude == null) {
      this.latitude = 13.04282;
      this.longitude = 80.23418;
      this.currentCoordinate = LatLng(latitude, longitude);
      this.lastKnownCoordinates = LatLng(latitude, longitude);
    }
    return this.currentCoordinate;
  }
}
