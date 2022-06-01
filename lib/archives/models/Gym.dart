import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:spotter/archives/Utils/Converter.dart';

class Gym {
  Image icon;
  String name;
  String address;
  List<String> images;
  HashMap location;
  List<String> equipments;
  List<String> amenities;
  List<String> partnerBenefits;
  double distance;
  HashMap workingHours;
  double rating;

  Gym getGym(Map<String, dynamic> request) {
    Gym gym = new Gym();
    gym.name = request["name"];
    gym.address = request["address"];
    gym.images = Converter.convertDynamicToString(request["images"]);
    print("Type of Hashmap: " + request["location"].runtimeType.toString());
    // gym.location = request["location"];
    gym.equipments = Converter.convertDynamicToString(request["equipments"]);
    // gym.partnerBenefits = request["partner_benefits"];
    gym.distance = double.parse(request["distance"]);
    // gym.workingHours = request["opening_hours"];
    // gym.rating = double.parse(request["rating"]);
    return gym;
  }
}
