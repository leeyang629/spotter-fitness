import 'package:spotter/utils/utils.dart';

class GymLocation {
  String name = "";
  String address = "-";
  String about = "-";
  List<double> location;
  String rating = "-";
  List<String> imageURLs = [];
  String phone = "-";
  List<String> equipments = [];
  List<String> aminities = [];
  List<String> specialization = [];
  bool onboarded = false;
  String dropInFee = "";
  GymLocation(this.name, this.location,
      {this.rating,
      this.about,
      this.imageURLs,
      this.address,
      this.phone,
      this.equipments,
      this.aminities,
      this.specialization,
      this.onboarded,
      this.dropInFee});

  GymLocation.fromJson(Map<String, dynamic> json,
      {bool spotterOnboarded = false}) {
    if (spotterOnboarded) {
      onboarded = true;
      name = json["onboardedInformations"]["name"];
      if (json["onboardedInformations"]["longitude"] != null &&
          json["onboardedInformations"]["latitude"] != null) {
        location = [
          json["onboardedInformations"]["latitude"],
          json["onboardedInformations"]["longitude"]
        ];
      } else if (json["googleDataAvailable"]) {
        location = [json['location']['lat'], json['location']['lng']];
      }
      rating = json['rating'] != null ? json['rating'].toString() : '-';
      if (json["onboardedInformations"]["addressLine1"] != null ||
          json["onboardedInformations"]["addressLine2"] != null ||
          json["onboardedInformations"]["city"] != null ||
          json["onboardedInformations"]["state"] != null ||
          json["onboardedInformations"]["country"] != null) {
        address =
            "${json["onboardedInformations"]["addressLine1"] != null ? (json["onboardedInformations"]["addressLine1"] + ", ") : ''} ${json["onboardedInformations"]["addressLine2"] != null ? (json["onboardedInformations"]["addressLine2"] + ", ") : ''} ${json["onboardedInformations"]["city"] != null ? (json["onboardedInformations"]["city"] + ", ") : ''} ${json["onboardedInformations"]["state"] != null ? (json["onboardedInformations"]["state"] + ", ") : ''} ${json["onboardedInformations"]["country"] != null ? (json["onboardedInformations"]["country"] + ", ") : ''}";
      } else
        address = json['address'];
      if (json['onboardedInformations']["imageUrls"] != null &&
          json['onboardedInformations']["imageUrls"].length > 0) {
        json['onboardedInformations']['imageUrls'].forEach((link) {
          imageURLs.add(link["url"]);
        });
      } else if (json['images'] != null && json['images']['links'] != null) {
        json['images']['links'].forEach((link) {
          imageURLs.add(link);
        });
      }
      phone = json['onboardedInformations']['phone'] ?? "";
      if (json['onboardedInformations']["otherInformation"] != null) {
        if (isNotEmpty(
            json['onboardedInformations']["otherInformation"]["equipment"])) {
          json['onboardedInformations']["otherInformation"]["equipment"]
              .forEach((equipment) => equipments.add(equipment));
        }
        if (isNotEmpty(
            json['onboardedInformations']["otherInformation"]["aminities"])) {
          json['onboardedInformations']["otherInformation"]["aminities"]
              .forEach((aminity) => aminities.add(aminity));
        }
        if (isNotEmpty(json['onboardedInformations']["otherInformation"]
            ["specialization"])) {
          json['onboardedInformations']["otherInformation"]["specialization"]
              .forEach((speciality) => specialization.add(speciality));
        }
      }
      if (json['onboardedInformations']["otherInformation"] != null &&
          json['onboardedInformations']["otherInformation"]["about"] != null &&
          json['onboardedInformations']["otherInformation"]["about"] != "") {
        about = json['onboardedInformations']["otherInformation"]["about"];
      }
      if (json['onboardedInformations']["otherInformation"] != null &&
          json['onboardedInformations']["otherInformation"]["dropInFee"] !=
              null &&
          json['onboardedInformations']["otherInformation"]["dropInFee"] !=
              "") {
        dropInFee =
            json['onboardedInformations']["otherInformation"]["dropInFee"];
      }
    } else {
      name = json['name'];
      location = [json['location']['lat'], json['location']['lng']];
      rating = json['rating'].toString();
      address = json['address'];
      if (json['images'] != null && json['images']['links'] != null) {
        json['images']['links'].forEach((link) {
          imageURLs.add(link);
        });
      }
    }
    print(name);
  }
}

class GymLocations {
  List<GymLocation> gyms = [];

  GymLocations(this.gyms);

  GymLocations.fromJSON(Map<String, dynamic> response) {
    response['spotter_response']['candidate'].forEach((gymJson) {
      gyms.add(new GymLocation.fromJson(gymJson, spotterOnboarded: true));
    });
    response['google_response']['candidate'].forEach((gymJson) {
      gyms.add(new GymLocation.fromJson(gymJson));
    });
  }
}

// Dummy Data
GymLocations gymLocations = new GymLocations([
  GymLocation("Gym1Gym1Gym1Gy", [37.785834, -122.406417]),
  GymLocation("Gym2", [37.79100837078643, -122.41706181317568]),
  GymLocation("Gym3", [37.785427203559316, -122.41349983960392]),
  GymLocation("Gym4", [37.7837022133037, -122.40417279303074]),
  GymLocation("Gym5", [37.79357915878893, -122.40104332566261]),
  GymLocation("Gym6", [37.78002448445597, -122.40491408854724]),
]);
