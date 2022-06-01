import 'dart:collection';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:spotter/archives/models/Gym.dart';

class Converter {
  static Future<Map<String, dynamic>> loadJSONFromString(String data) async {
    String assetFromFile = await rootBundle.loadString(data);
    Map<String, dynamic> decodedValue = json.decode(assetFromFile);
    // print("Asset from file " + decodedValue.toString());
    return decodedValue;
  }

  static Future<Map<String, dynamic>> loadJSONFromURL(String url) async {
    Response response = await _fetchData(url);
    print(response.body);
    Map<String, dynamic> responseJSON = jsonDecode(response.body);
    jsonToGymsList(responseJSON);
    return responseJSON;
  }

  static Future<Response> _fetchData(String url) async {
    return Client().get(Uri.parse(url));
  }

  static List<Gym> jsonToGymsList(Map<String, dynamic> data) {
    List<dynamic> gymsData = data['response']['candidate'];
    List<Gym> gyms = [];
    gymsData.forEach((element) {
      Gym gym = new Gym();
      // gym.icon = Image.network(element["icon"]);
      gym.name = element["name"];
      gym.rating = element["rating"].toDouble();
      gym.images = element["images"] == null
          ? null
          : new List<String>.from(element["images"]["links"]);
      gym.distance = element["distance"] / 1000;
      print(gym.name);
      gyms.add(gym);
    });
    return gyms;
  }

  static convertDynamicToString(List<dynamic> listData) {
    return listData?.cast<String>();
  }

  static convertDynamicToHashMap(List<dynamic> listData) {
    // ignore: unused_local_variable
    HashMap data = new HashMap<String, dynamic>();
    listData.forEach((element) {
      print(element);
    });
    // listData.forEach((element) {
    //   data.addEntries("");
    // })

    return null;
  }
}
