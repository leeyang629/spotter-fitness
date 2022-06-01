class TrainerDetails {
  String name = "";
  String mainSpecialization = "";
  String city = "-";
  String rating = "-";
  String following = "-";
  String followers = "-";
  String facebook = "";
  String twitter = "";
  String instagram = "";
  String youtube = "";
  String price = "-";
  bool showPrice = true;
  String certifications = "-";
  String publications = "-";
  String conferences = "-";
  String imageURL = "";
  bool userIsFollowing = false;
  List<String> specialization = [];

  TrainerDetails({this.name});

  TrainerDetails.fromJson(Map<String, dynamic> json) {
    if (json["onboardedInformation"] != null) {
      if (json["onboardedInformation"]["city"] != null &&
          json["onboardedInformation"]["city"] != "")
        city = json["onboardedInformation"]["city"];
      if (json["onboardedInformation"]["onboarding_information"] != null) {
        final onboardingInfo =
            json["onboardedInformation"]["onboarding_information"];
        if (onboardingInfo["displayPrice"] == "No") {
          showPrice = false;
        }
        if (onboardingInfo["price"] != null && onboardingInfo["price"] != "")
          price = onboardingInfo["price"];
        if (onboardingInfo["certifications"] != null) {
          certifications = onboardingInfo["certifications"];
        }
        if (onboardingInfo["publications"] != null) {
          certifications = onboardingInfo["publications"];
        }
        if (onboardingInfo["conferences"] != null) {
          certifications = onboardingInfo["conferences"];
        }
        if (onboardingInfo["socialMedia"] != null) {
          facebook = onboardingInfo["socialMedia"]["Facebook Profile Url"];
          instagram = onboardingInfo["socialMedia"]["Instagram ID"];
          twitter = onboardingInfo["socialMedia"]["Twitter ID"];
          youtube = onboardingInfo["socialMedia"]["Youtube Channel Url"];
        }
        if (onboardingInfo["specialization"] != null &&
            onboardingInfo["specialization"].length > 0)
          onboardingInfo["specialization"]
              .forEach((speciality) => specialization.add(speciality));
      }
    }
    if (json["rating"] != null && json["rating"] != "") {
      rating = json["rating"];
    }
    if (json["followers"] != null && json["followers"] != "") {
      rating = json["followers"];
    }
    if (json["following"] != null && json["following"] != "") {
      rating = json["following"];
    }
    if (json["image_url"] != null && json["image_url"] != "") {
      imageURL = json["image_url"];
    }
    name = json["first_name"];
    userIsFollowing = json["is_followed"];
    followers = json["follow_users_count"]?.toString();
  }
}
