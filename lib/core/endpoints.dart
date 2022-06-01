class ApiEndPoints {
  String location;
  String googlePlaceAuto;
  String googlePlaceDetail;
  String user;
  String company;

  ApiEndPoints({location, user, googlePlaceAuto, googlePlaceDetail, company}) {
    this.location = location;
    this.googlePlaceAuto = googlePlaceAuto;
    this.googlePlaceDetail = googlePlaceDetail;
    this.user = user;
    this.company = company;
  }
}

ApiEndPoints developmentApiUrls = ApiEndPoints(
    location: "https://location-service-dev.spotter-api.com/",
    user: "https://user-service-dev.spotter-api.com",
    googlePlaceAuto:
        "https://maps.googleapis.com/maps/api/place/autocomplete/json",
    googlePlaceDetail:
        "https://maps.googleapis.com/maps/api/place/details/json",
    company: "https://company-service-dev.spotter-api.com");

ApiEndPoints productionApiUrls = ApiEndPoints(
    location: "https://location-service-production.spotter-api.com/",
    user: "https://spotter-user.herokuapp.com",
    googlePlaceAuto:
        "https://maps.googleapis.com/maps/api/place/autocomplete/json",
    googlePlaceDetail:
        "https://maps.googleapis.com/maps/api/place/details/json",
    company: "https://company-service-production.spotter-api.com");

ApiEndPoints localApiUrls = ApiEndPoints(
    location: "https://spotter-user.herokuapp.com",
    user: "https://spotter-user.herokuapp.com",
    googlePlaceAuto:
    "https://maps.googleapis.com/maps/api/place/autocomplete/json",
    googlePlaceDetail:
    "https://maps.googleapis.com/maps/api/place/details/json",
    company: "https://company-service-production.spotter-api.com");
