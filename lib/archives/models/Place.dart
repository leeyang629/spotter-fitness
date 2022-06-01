import 'package:spotter/archives/models/Amenity.dart';
import 'package:spotter/archives/models/Equipment.dart';

class Place {
  final String name;
  final List<String> images;
  final String address;
  final int rating;
  final List<Equipment> equipments;
  final List<Amenity> amenities;

  Place(this.name, this.images, this.address, this.rating, this.equipments,
      this.amenities);
}
