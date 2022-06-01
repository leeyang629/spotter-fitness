import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spotter/Components/common/LoadingIndicator.dart';
import 'package:spotter/archives/Location.dart';

class LocationModel extends ChangeNotifier {
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    mapController = controller;
  }

  Future<LatLng> getCurrentLocation() async {
    Location location = new Location();
    var result = await location.getCurrentLocation();
    return result;
  }

  Future<CameraPosition> getCameraPosition(LatLng location) async {
    final CameraPosition cameraPosition = CameraPosition(
      target: location,
      zoom: 18,
    );
    return cameraPosition;
  }

  Set<Marker> setMarkers(LatLng coordinates) {
    // final Map<String, Marker> _markers = {};
    Marker currentLocationMarker = Marker(
        markerId: MarkerId("Current LOC"),
        position: coordinates,
        infoWindow: InfoWindow(
            title: "Your current location", snippet: coordinates.toString()));
    return <Marker>{currentLocationMarker};
  }

  Future<GoogleMap> initMap() async {
    LatLng currentLocation = await getCurrentLocation();
    CameraPosition currentCamera = await getCameraPosition(currentLocation);
    GoogleMap map = new GoogleMap(
      initialCameraPosition: currentCamera,
      mapType: MapType.normal,
      markers: setMarkers(currentLocation),
      onMapCreated: _onMapCreated,
    );
    return map;
  }

  FutureBuilder<GoogleMap> initGoogleMap() {
    return FutureBuilder<GoogleMap>(
        future: initMap(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data;
          } else {
            return LoadingIndicator();
          }
        });
  }

  void moveCameraToCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        await getCameraPosition(await getCurrentLocation())));
  }
}
