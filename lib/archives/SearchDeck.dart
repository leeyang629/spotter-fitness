import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/archives/ListPage.dart';

import 'LocationModel.dart';

class SearchDeck extends StatefulWidget {
  @override
  _SearchDeckState createState() => _SearchDeckState();
}

class _SearchDeckState extends State<SearchDeck> {
  bool _isSearchSelected = false;

  // ignore: missing_return
  Future<bool> onWillPop() {
    setState(() {
      _isSearchSelected = false;
    });
  }

  Widget searchResults(context) {
    if (!_isSearchSelected) {
      return new WillPopScope(
          onWillPop: onWillPop,
          child: Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3.5,
                child: Align(
                  child: Consumer<LocationModel>(
                    builder: (context, mapModel, child) {
                      return MaterialButton(
                        shape: CircleBorder(),
                        // onPressed: () => _moveMapToCurrentPosition(context),
                        onPressed: searchButtonPressed,
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Image.asset(
                            "assets/images/SpotIcon_Button_R2.png",
                            scale: 0.5,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )));
    }
    return Positioned(
      bottom: 0,
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3.5,
          child: Align(child: ListGymsPage())),
    );
  }

  void searchButtonPressed() {
    setState(() {
      _isSearchSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return searchResults(context);
  }

  // ignore: unused_element
  void _moveMapToCurrentPosition(BuildContext context) {
    return Provider.of<LocationModel>(context, listen: false)
        .moveCameraToCurrentLocation();
  }
}
