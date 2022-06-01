import 'package:flutter/material.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/core/http.dart';
import 'package:spotter/api_keys.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

class AutoCompleteLocation {
  String description;
  String placeId;

  AutoCompleteLocation(this.description, this.placeId);

  AutoCompleteLocation.toJSON(String desc, String id) {
    description = desc;
    placeId = id;
  }
}

class MapSearch extends StatefulWidget {
  final Function(Position) searchCurrentLocation;
  final Function resetCurrentLocation;
  final bool hasFocus;
  final Function setFocus;
  MapSearch(this.searchCurrentLocation, this.resetCurrentLocation,
      this.hasFocus, this.setFocus);
  @override
  MapSearchState createState() => MapSearchState();
}

class MapSearchState extends State<MapSearch> {
  TextEditingController textController = TextEditingController();
  int deboundTime = 750;
  Timer deboundTimer;
  List<AutoCompleteLocation> autoCompleteLocations = [];

  @override
  void initState() {
    super.initState();
    textController.addListener(() {
      if (deboundTimer != null) {
        deboundTimer.cancel();
      }
      deboundTimer = new Timer(Duration(milliseconds: 500), () {
        print("Debounce crossed");
        if (textController.text != "") {
          fetchSuggestion();
        } else {
          if (autoCompleteLocations.length > 0) {
            setState(() {
              autoCompleteLocations = [];
            });
          }
        }
      });
    });
  }

  fetchSuggestion() async {
    final apiCall = HttpClient(productionApiUrls.googlePlaceAuto);
    final sessionToken = Uuid().v4();
    final result = await apiCall.get(
        "?input=${textController.text}&key=$googleMapAPIKey&sessiontoken=$sessionToken");
    // print(result);
    if (result['predictions'].length > 0) {
      List<AutoCompleteLocation> list = [];
      result['predictions'].forEach((location) {
        list.add(new AutoCompleteLocation.toJSON(
          location["description"],
          location["place_id"],
        ));
      });
      setState(() {
        autoCompleteLocations = list;
      });
      // print("autoCompleteLocations");
      // print(autoCompleteLocations);
    }
  }

  suggestionClicked(String id, String description) async {
    setState(() {
      autoCompleteLocations = [];
    });
    widget.setFocus(false);
    FocusManager.instance.primaryFocus.unfocus();
    textController.text = description;
    final apiCall = HttpClient(productionApiUrls.googlePlaceDetail);
    final result = await apiCall.get("?place_id=$id&key=$googleMapAPIKey");
    if (result["result"] != null) {
      Position location = new Position(
          longitude: result["result"]["geometry"]["location"]["lng"],
          latitude: result["result"]["geometry"]["location"]["lat"]);
      if (location != null) {
        widget.searchCurrentLocation(location);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // hasFocus
        // ?
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(
              0, widget.hasFocus ? 0 : -MediaQuery.of(context).size.height, 0),
          padding: const EdgeInsets.only(left: 15),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 115,
              ),
              Expanded(
                  child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) => Divider(
                  thickness: 1.5,
                ),
                itemCount: autoCompleteLocations.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      suggestionClicked(autoCompleteLocations[index].placeId,
                          autoCompleteLocations[index].description);
                    },
                    child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          autoCompleteLocations[index].description,
                          textAlign: TextAlign.left,
                        )),
                  );
                },
              ))
            ],
          ),
        ),
        // : Container(),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.1,
          right: 10,
          width:
              MediaQuery.of(context).size.width - (widget.hasFocus ? 20 : 50),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.hasFocus
                    ? GestureDetector(
                        onTap: () {
                          widget.setFocus(false);
                          FocusManager.instance.primaryFocus.unfocus();
                        },
                        child: Icon(Icons.arrow_back))
                    : Container(),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    // focusNode: _focusNode,
                    onTap: () {
                      widget.setFocus(true);
                    },
                    controller: textController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(right: 20),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            borderSide: BorderSide(color: Colors.grey)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            borderSide: BorderSide(color: Colors.grey)),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Search",
                        prefixIcon:
                            Icon(Icons.search), // myIcon is a 48px-wide widget.
                        isDense: true),
                  ),
                )
              ],
            ),
          ),
        ),
        textController.text != ""
            ? Positioned(
                top: MediaQuery.of(context).size.height * 0.1,
                right: 30,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: GestureDetector(
                    child: Container(
                        color: Colors.white, child: Icon(Icons.close)),
                    onTap: () {
                      textController.text = "";
                      widget.resetCurrentLocation();
                    },
                  ),
                ))
            : Container()
      ],
    );
  }
}
