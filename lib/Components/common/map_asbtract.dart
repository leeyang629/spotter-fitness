import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapLayer extends StatefulWidget {
  final GoogleMapController mapController;
  final Function(GoogleMapController) setMapController;
  final Position currentLocation;
  final Map<String, Marker> markers;
  final Function(Position, int, String) addMarkers;
  final Function(LatLng) onMapTap;
  MapLayer(
      {this.mapController,
      this.setMapController,
      this.currentLocation,
      this.markers,
      this.addMarkers,
      this.onMapTap});
  @override
  State<MapLayer> createState() => MapState();
}

class MapState extends State<MapLayer> {
  Completer<GoogleMapController> _controller = Completer();
  String _mapStyle;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_styles.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _initialCameraPosition(),
      onMapCreated: (GoogleMapController controller) async {
        _controller.complete(controller);
        widget.setMapController(controller);
        controller.setMapStyle(_mapStyle);
        addCurrentLocationMarker();
      },
      onTap: widget.onMapTap,
      zoomControlsEnabled: false,
      // onCameraMove: (CameraPosition position) {
      //   if (deboundTimer != null) {
      //     deboundTimer.cancel();
      //   }
      //   deboundTimer = new Timer(Duration(milliseconds: 500), () {
      //     print("Debounce crossed");
      //     getMapBounds();
      //   });
      // },
      markers: widget.markers.values.toSet(),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }

  CameraPosition _initialCameraPosition() {
    if (widget.currentLocation != null) {
      return CameraPosition(
        target: LatLng(
            widget.currentLocation.latitude, widget.currentLocation.longitude),
        zoom: 14.4746,
      );
    }
    return CameraPosition(
      target: LatLng(40.7128, -74.0060),
      zoom: 14.4746,
    );
  }

  addCurrentLocationMarker() {
    widget.addMarkers(widget.currentLocation, -1, 'current');
  }
}
