import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:spotter/Components/common/map_asbtract.dart';
import 'package:spotter/Components/screens/map/gym_details.dart';
import 'package:spotter/core/http.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:spotter/utils/permissions.dart';
import './gym_carousel.dart';
import './marker.dart';
import './gyms_list.dart';
import 'map_search.dart';

class MapView extends StatefulWidget {
  @override
  State<MapView> createState() => MapSampleState();
}

class MapSampleState extends State<MapView> with TickerProviderStateMixin {
  GoogleMapController mapController;
  bool locationFound = false;
  Position currentLocation;
  Position actualCurrentLocation;
  int deboundTime = 500;
  Timer deboundTimer;
  BitmapDescriptor markerIcon;
  final Map<String, Marker> _markers = {};
  int gymSelected = -1;
  List<GymLocation> nearByGyms = [];
  List<GymLocation> defaultNearByGyms = [];
  bool hasSearchFocus = false;
  Animation _openCarousel;
  AnimationController openCarouselController;
  bool carouselOpen = true;
  bool openGymDetails = false;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    openCarouselController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    _openCarousel = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
        parent: openCarouselController, curve: Curves.easeInOutCubic));
  }

  setSearchFocus(bool flag) {
    setState(() {
      hasSearchFocus = flag;
    });
  }

  Future<bool> _backButtonPressed() async {
    if (hasSearchFocus) {
      setSearchFocus(false);
      FocusManager.instance.primaryFocus.unfocus();
      return Future.delayed(Duration(seconds: 0), () {
        return false;
      });
    } else if (openGymDetails) {
      setOpenGymDetails(false);
      return Future.delayed(Duration(seconds: 0), () {
        return false;
      });
    } else {
      Navigator.pop(context, true);
    }
    return Future.delayed(Duration(seconds: 0), () {
      return false;
    });
  }

  setMapController(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: (locationFound)
          ? WillPopScope(
              onWillPop: _backButtonPressed,
              child: Stack(children: [
                MapLayer(
                  currentLocation: currentLocation,
                  addMarkers: addMarkers,
                  markers: _markers,
                  mapController: mapController,
                  setMapController: setMapController,
                ),
                Positioned(
                  left: 10,
                  top: MediaQuery.of(context).size.height * 0.1,
                  child: SizedBox(
                    width: 40,
                    child: TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(0)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey[200]),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                          )),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        )),
                  ),
                ),
                AnimatedBuilder(
                    animation: _openCarousel,
                    builder: (BuildContext context, child) => Container(
                        transform: Matrix4.translationValues(
                            0,
                            MediaQuery.of(context).size.height -
                                240.0 * _openCarousel.value,
                            0),
                        width: MediaQuery.of(context).size.width,
                        height: 160,
                        child: new GymCarousel(nearByGyms, gymSelected,
                            setSelectedGym, setOpenGymDetails))),
                Positioned(
                    child: InkWell(
                      onTap: () {
                        if (carouselOpen) {
                          openCarouselController.forward();
                          setState(() {
                            carouselOpen = false;
                          });
                        } else {
                          openCarouselController.reverse();
                          setState(() {
                            carouselOpen = true;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: carouselOpen
                            ? Icon(
                                Icons.cancel,
                                size: 32,
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.expand_less,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                      ),
                    ),
                    bottom: 12,
                    left: MediaQuery.of(context).size.width * 0.5 - 36),
                MapSearch(setCurrentLocation, resetCurrentLocation,
                    hasSearchFocus, setSearchFocus),
                openGymDetails
                    ? GymDetails(
                        setOpenGymDetails: setOpenGymDetails,
                        openGymDetails: openGymDetails,
                        selectedGymDetails:
                            gymSelected > -1 ? nearByGyms[gymSelected] : null,
                      )
                    : Container(),
              ]),
            )
          : Container(),
    );
  }

  void setOpenGymDetails(bool value) {
    setState(() {
      openGymDetails = value;
    });
  }

  void setSelectedGym(int index) {
    setState(() {
      gymSelected = index;
    });
    loadMarkers();
    panToSelectedMarker(nearByGyms[gymSelected].location[0],
        nearByGyms[gymSelected].location[1]);
  }

  loadMarkers() async {
    if (nearByGyms != null && nearByGyms.length > 0) {
      new Timer(Duration(milliseconds: 250), () {
        for (int i = 0; i < nearByGyms.length; i++) {
          if (nearByGyms[i].location != null)
            addMarkers(
                LatLng(nearByGyms[i].location[0], nearByGyms[i].location[1]),
                i,
                nearByGyms[i].name);
        }
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

  Future<void> getCurrentLocation() async {
    Position location = await getPermission();
    print(location);
    setState(() {
      currentLocation =
          Position(latitude: location.latitude, longitude: location.longitude);
      actualCurrentLocation =
          Position(latitude: location.latitude, longitude: location.longitude);
      locationFound = true;
    });
    await callApiForGyms();
    backupDefaultNearByGyms();
  }

  backupDefaultNearByGyms() {
    setState(() {
      defaultNearByGyms = nearByGyms;
    });
  }

  callApiForGyms() async {
    final apiCall = HttpClient(productionApiUrls.location);
    try {
      final result = await apiCall.get(
          'api/v1/places/nearby_search?lat=${currentLocation.latitude}&long=${currentLocation.longitude}&type=gym&radius=${Provider.of<AppState>(context, listen: false).radius * 1609}&keyword=fitness&key=AIzaSyDaKIvY00efVgt31gGONNe6ov6peGsphi4',
          withAuthHeaders: true);
      print(result);
      GymLocations list = new GymLocations.fromJSON(result);
      setState(() {
        nearByGyms = list.gyms;
      });
      await loadMarkers();
    } catch (e) {
      print("error");
      print(e);
    }
  }

  addCurrentLocationMarker() {
    addMarkers(currentLocation, -1, 'current');
  }

  addMarkers(location, int index, String key) async {
    dynamic marker = MarkerIcon(context);
    dynamic icon = await marker.createMarkerWithText(
        "", index == gymSelected ? 40.0 : 30.0);
    setState(() {
      _markers[key] = Marker(
          onTap: () {
            setState(() {
              gymSelected = index;
            });
            loadMarkers();
            // print(index);
          },
          markerId: MarkerId(key),
          icon: key == 'current' ? BitmapDescriptor.defaultMarker : icon,
          position: LatLng(location.latitude, location.longitude));
    });
  }

  Marker placeMarkers() {
    if (markerIcon != null) {
      // print("icon");
      // print(markerIcon);
      return Marker(
        markerId: MarkerId("marker-1"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        icon: markerIcon,
      );
    } else {
      return Marker(
        markerId: MarkerId("marker-1"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
      );
    }
  }

  Future<void> getMapBounds() async {
    if (mapController != null) {
      //LatLngBounds bounds = await mapController.getVisibleRegion();
      // print("bounds");
      // print(bounds);
    }
  }

  void setCurrentLocation(Position location) async {
    setState(() {
      currentLocation = location;
      nearByGyms = [];
      _markers.clear();
      gymSelected = -1;
    });
    await loadMarkers();
    panToSelectedMarker(currentLocation.latitude, currentLocation.longitude);
    addCurrentLocationMarker();
    callApiForGyms();
  }

  void resetCurrentLocation() {
    setState(() {
      currentLocation = actualCurrentLocation;
      nearByGyms = defaultNearByGyms;
      _markers.clear();
      gymSelected = -1;
    });
    addCurrentLocationMarker();
    panToSelectedMarker(currentLocation.latitude, currentLocation.longitude);
    loadMarkers();
  }
}
