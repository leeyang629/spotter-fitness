import 'package:flutter/material.dart';
import 'package:spotter/Components/screens/user_profile/model.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/core/http.dart';
import 'package:spotter/core/storage.dart';
import 'package:provider/provider.dart';
import 'package:spotter/notification_utils/register_notifications.dart';
import 'package:spotter/providers/app_state.dart';

Future getUserData(BuildContext context) async {
  final api = HttpClient(productionApiUrls.user);
  final SecureStorage storage = SecureStorage();
  final persona = await storage.getPersona();
  final permalink = await storage.getPermalink();
  final radius = await storage.getRadius();
  final notifications = await storage.getNotifications();
  Provider.of<AppState>(context, listen: false)
      .saveRadius(double.parse(radius ?? '5'));
  if (notifications == "false") {
    Provider.of<AppState>(context, listen: false).saveNotifications(false);
  } else {
    Provider.of<AppState>(context, listen: false).saveNotifications(true);
  }

  try {
    if (permalink != "" || permalink != null) {
      Provider.of<AppState>(context, listen: false)
          .saveUserPermalink(permalink);
      final result =
          await api.get("/api/v1/users/$permalink", withAuthHeaders: true);
      // print(result["user"]);
      if (result["statusCode"] == 200) {
        Provider.of<AppState>(context, listen: false)
            .setUserName(result["user"]["first_name"]);
        Provider.of<AppState>(context, listen: false)
            .setUserImgUrl(result["user"]["image_url"]);
        final onboarded = result["user"]["onboarded"];
        if (persona == "user" && onboarded == true) {
          Provider.of<AppState>(context, listen: false).setOnboardData(
              UserDetails.fromJson(result["user"]["onboardedInformation"]
                  ["onboarding_information"]));
        }
        if (persona == "owner") {
          if (result["user"]["company_id"] != null &&
              result["user"]["company_id"] != "") {
            final companyId = result["user"]["company_id"];
            print(companyId);
            final SecureStorage storage = SecureStorage();
            await storage.saveCompanyPermalink(companyId);
            await getGymDetails(context, companyId);
          }
        }
        await loadStoreToState(onboarded ?? false, context);
        if (persona != "owner") await registerForNotifications(context);
      }
      return result;
    } else {
      goToLoginPage(context);
    }
  } catch (e) {
    print(e);
    return Future.error(e.toString());
  }
}

Future fetchUserData(BuildContext context, String permalink) async {
  final api = HttpClient(productionApiUrls.user);
  try {
    Provider.of<AppState>(context, listen: false).enableSpinner();
    final result =
        await api.get("/api/v1/users/$permalink", withAuthHeaders: true);
    Provider.of<AppState>(context, listen: false).disableSpinner();
    // print(result["user"]);
    if (result["statusCode"] == 200) {
      return result["user"];
    }
  } catch (e) {
    print(e);
    Provider.of<AppState>(context, listen: false).disableSpinner();
  }
}

Future getGymDetails(BuildContext context, String companyId) async {
  try {
    final SecureStorage storage = SecureStorage();
    final api = HttpClient(productionApiUrls.company);
    final result =
        await api.get("/companies/$companyId", withAuthHeaders: true);
    print(result);
    await storage.saveUsername(result["company"]["name"]);
    Provider.of<AppState>(context, listen: false)
        .setUserName(result["company"]["name"]);
    if (result["company"]["imageUrls"] != null &&
        result["company"]["imageUrls"].length > 0) {
      await storage.saveUserImgUrl(result["company"]["imageUrls"][0]["url"]);
      Provider.of<AppState>(context, listen: false)
          .setUserImgUrl(result["company"]["imageUrls"][0]["url"]);
    }
    return result["company"];
  } catch (e) {
    print("error");
    print(e);
  }
}

loadStoreToState(bool onboarded, BuildContext context) async {
  final SecureStorage storage = SecureStorage();
  final radius = await storage.getRadius();
  if (radius != null) {
    Provider.of<AppState>(context, listen: false)
        .saveRadius(double.parse(radius));
  }
  final notifications = await storage.getNotifications();
  if (notifications != null) {
    Provider.of<AppState>(context, listen: false)
        .saveNotifications((notifications != null && notifications != "false"));
  }

  await checkUserLoginStatus(onboarded, context);
}

checkUserLoginStatus(bool onboarded, BuildContext context) async {
  final SecureStorage storage = SecureStorage();
  String token = await storage.getUserToken();
  if (token != "" && token != null) {
    checkPersona(onboarded, context);
  } else {
    goToLoginPage(context);
  }
}

goToLoginPage(BuildContext context) async {
  final SecureStorage storage = SecureStorage();
  await storage.deleteUserData();
  String persona = await storage.getPersona();
  print(persona);
  if (persona == "" || persona == null) {
    persona = "user";
    await storage.savePersona("user");
  }
  Provider.of<AppState>(context, listen: false)
      .setUserPersona(persona ?? "user");
  if (persona == "user") {
    Navigator.pushReplacementNamed(context, '/login');
  } else if (persona == "trainer") {
    Navigator.pushReplacementNamed(context, '/trainer_login');
  } else if (persona == "owner" || persona == "gym_owner") {
    Navigator.pushReplacementNamed(context, '/gym_login');
  }
}

checkPersona(bool onboarded, BuildContext context) async {
  final SecureStorage storage = SecureStorage();
  String persona = await storage.getPersona();
  Provider.of<AppState>(context, listen: false)
      .setUserPersona(persona ?? "user");
  if (persona == "" || persona == null) {
    await storage.savePersona("user");
    Navigator.pushReplacementNamed(context, '/login');
  } else if (onboarded) {
    goToLandingScreen(persona, context);
  } else if (!onboarded) {
    goToLandingScreen(persona, context);
    // goToOnboarding(persona, context);
  }
}

goToLandingScreen(String persona, BuildContext context) {
  if (persona == "user") {
    Navigator.pushReplacementNamed(context, '/trainers_list');
  } else if (persona == "trainer") {
    Navigator.pushReplacementNamed(context, '/trainer_dashboard');
  } else {
    Navigator.pushReplacementNamed(context, '/gym_dashboard');
  }
}

goToOnboarding(String persona, BuildContext context) {
  if (persona == "user") {
    Navigator.pushReplacementNamed(context, '/user_profile_setup');
  } else if (persona == "trainer") {
    Navigator.pushReplacementNamed(context, '/trainer_profile_setup');
  } else {
    Navigator.pushReplacementNamed(context, '/gym_owner_profile_setup');
  }
}
