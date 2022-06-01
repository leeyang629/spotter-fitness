import 'package:flutter/material.dart';
import 'package:spotter/archives/Common/Carousel/image_carousel.dart';
import 'package:spotter/archives/Utils/Converter.dart';
import 'package:spotter/archives/models/Gym.dart';

class PlacesInformationPage extends StatefulWidget {
  PlacesInformationPage({Key key}) : super(key: key);

  @override
  _PlacesInformationPageState createState() => _PlacesInformationPageState();
}

class _PlacesInformationPageState extends State<PlacesInformationPage> {
  // var data = Converter.loadJSONFromString("assets/dummy/json/gym_details.json");
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    Gym gymData = arguments['gym_detail'];
    Widget imageList;
    if (gymData.images == null) {
      imageList = Text("No Images Found");
    } else
      imageList = ImageCarousel(images: gymData.images);
    String baseUrl =
        "https://api.spotterfitness.org/api/v1/places/nearby_search";
    Converter.loadJSONFromURL(
        baseUrl + '?lat=-33.8670522&long=151.1957362&type=gym&radius=2300');
    // ignore: unused_local_variable
    Converter converter = new Converter();
    return FutureBuilder(
        future:
            Converter.loadJSONFromString("assets/dummy/json/gym_details.json"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> obj = snapshot.data;
            Gym gym = new Gym().getGym(obj);
            // ignore: unused_local_variable
            List<String> images = gym.images;
            // print("Type of Images: " + obj["imageList"]);
            return Container(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(gymData.name),
                  centerTitle: true,
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: imageList,
                      flex: 1,
                    ),
                    Expanded(
                      child: Text("data"),
                      flex: 1,
                    )
                  ],
                ),
              ),
            );
          } else {
            return Text("No JSON data");
          }
        });
  }
}
