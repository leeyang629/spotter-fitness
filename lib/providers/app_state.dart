import 'package:flutter/material.dart';
import 'package:spotter/Components/screens/user_profile/model.dart';

enum LoginTypes { spotter_login, google_login, fb_login }

class AppState extends ChangeNotifier {
  String userToken = "";
  String userName = "";
  String userEmail = "";
  String userPermalink = "";
  String userImgUrl = "";
  LoginTypes loginType = LoginTypes.spotter_login;
  bool spinner = false;
  String userPersona = "user";
  bool notifications = false;
  bool newMessage = false;
  double radius = 5;
  bool showSnackBar = false;
  String snackBarText = "";
  String currentRoute = "/";
  UserDetails onBoardData;

  void enableSpinner() {
    spinner = true;
    notifyListeners();
  }

  void disableSpinner() {
    spinner = false;
    notifyListeners();
  }

  void changeLoginType(LoginTypes type) {
    loginType = type;
  }

  void setUserName(String value) {
    userName = value;
  }

  void setEmailId(String value) {
    userEmail = value;
  }

  void setUserImgUrl(String value) {
    userImgUrl = value;
  }

  void setUserPersona(String value) {
    userPersona = value;
    notifyListeners();
  }

  void saveSettings(Map<String, dynamic> value) {
    notifications = value["notifications"];
    radius = value["radius"];
  }

  void saveNotifications(bool value) {
    notifications = value;
    notifyListeners();
  }

  void saveRadius(double value) {
    radius = value;
    notifyListeners();
  }

  void saveUserPermalink(String value) {
    userPermalink = value;
  }

  void setNewIncomingMessage() {
    newMessage = true;
    notifyListeners();
  }

  void resetNewMessageIndicator() {
    newMessage = false;
    notifyListeners();
  }

  void displaySnackBar(String value) {
    snackBarText = value;
    showSnackBar = true;
    notifyListeners();
  }

  void hideSnackBar() {
    showSnackBar = false;
    notifyListeners();
  }

  void setCurrentRoute(String value) {
    currentRoute = value;
  }

  void setOnboardData(UserDetails data) {
    onBoardData = data;
  }
}
