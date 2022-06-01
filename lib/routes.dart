import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/Components/screens/appointment/appointment_booked.dart';
import 'package:spotter/Components/screens/appointment/book_appointment.dart';
import 'package:spotter/Components/screens/chat/chat.dart';
import 'package:spotter/Components/screens/dashboard/gym/dashboard.dart';
import 'package:spotter/Components/screens/dashboard/trainer/dashboard.dart';
import 'package:spotter/Components/screens/dashboard/trainer/schedule_details.dart';
import 'package:spotter/Components/screens/dashboard/trainer/start_session.dart';
import 'package:spotter/Components/screens/discover_activities/discover_activities.dart';
import 'package:spotter/Components/screens/gym_profile/gym_profile.dart';
import 'package:spotter/Components/screens/home/home.dart';
import 'package:spotter/Components/screens/login/gym/gym_login.dart';
import 'package:spotter/Components/screens/login/trainer/trainer_login.dart';
import 'package:spotter/Components/screens/login/user/user_login.dart';
import 'package:spotter/Components/screens/map/map.dart';
import 'package:spotter/Components/screens/profile_setup/common/set_location.dart';
import 'package:spotter/Components/screens/purchases/purchases.dart';
import 'package:spotter/Components/screens/schedule/check_in.dart';
import 'package:spotter/Components/screens/schedule/schedule.dart';
import 'package:spotter/Components/screens/settings/settings.dart';
import 'package:spotter/Components/screens/sign_up/sign_up.dart';
import 'package:spotter/Components/screens/user_profile/user_profile.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:spotter/update_app.dart';

import 'Components/screens/profile_setup/user/profile_setup.dart';
import 'Components/screens/profile_setup/trainer/profile_setup.dart';
import 'Components/screens/profile_setup/gym_owner/profile_setup.dart';
import 'Components/screens/trainers_list/trainers_list.dart';
import 'Components/screens/trainer_profile/trainer_profile.dart';

RouteFactory routeConfiguration(BuildContext context) {
  void updateCurrentRoute(String value) {
    Provider.of<AppState>(context, listen: false).setCurrentRoute(value);
  }

  return (settings) {
    Map<String, dynamic> arguments = settings.arguments;
    Widget screen;
    switch (settings.name) {
      case '/login':
        screen = UserLogin();
        break;
      case '/trainer_login':
        screen = TrainerLogin();
        break;
      case '/gym_login':
        screen = GymLogin();
        break;
      case '/user_profile_setup':
        screen = UserProfileSetup();
        break;
      case '/update_user_profile_setup':
        screen = UserProfileSetup(
          update: true,
        );
        break;
      case '/register_user_profile':
        screen = UserProfileSetup(
          register: true,
        );
        break;
      case '/trainer_profile_setup':
        screen = TrainerProfileSetup();
        break;
      case '/register_trainer_profile':
        screen = TrainerProfileSetup(
          register: true,
        );
        break;
      case '/update_trainer_profile_setup':
        screen = TrainerProfileSetup(update: true);
        break;
      case '/gym_owner_profile_setup':
        screen = GymOwnerProfileSetup();
        break;
      case '/update_gym_profile_setup':
        screen = GymOwnerProfileSetup(update: true);
        break;
      case '/trainers_list':
        screen = TrainersList();
        break;
      case '/trainer_profile':
        screen = TrainerProfile(arguments["permalink"]);
        break;
      case '/trainer_profile_update':
        screen = TrainerProfile(arguments["permalink"], update: true);
        break;
      case '/user_profile':
        screen = UserProfile(arguments["permalink"]);
        break;
      case '/user_profile_update':
        screen = UserProfile(
          arguments["permalink"],
          update: true,
        );
        break;
      case '/signup':
        screen = SignUp();
        break;
      case '/map':
        screen = MapView();
        break;
      case '/discover_activities':
        screen = DiscoverActivities();
        break;
      case '/book_appointment':
        screen = BookAppointment(
          arguments["permalink"],
          name: arguments["name"],
          workouts: arguments["workouts"],
        );
        break;
      case '/update_appointment':
        screen = BookAppointment(
          arguments["permalink"],
          appointmentId: arguments["id"],
          name: arguments["name"],
          workouts: arguments["workouts"],
          action: "update",
        );
        break;
      case '/check_in':
        screen = CheckIn(arguments["id"]);
        break;
      case '/appointment_booked':
        screen = AppointmentBooked(arguments["name"]);
        break;
      case '/trainer_dashboard':
        screen = TrainerDashboard();
        break;
      case '/gym_dashboard':
        screen = GymDashboard();
        break;
      case '/gym_details_update':
        screen = GymProfile(arguments["permalink"]);
        break;
      case '/schedule':
        screen = Schedule();
        break;
      case '/schedule_details':
        screen = ScheduleDetail(arguments["id"]);
        break;
      case '/start_session':
        screen = StartSession(arguments["id"]);
        break;
      case '/settings':
        screen = Settings();
        break;
      case '/set_location':
        screen = SetLocation();
        break;
      case '/chat':
        screen = Chat();
        break;
      case '/purchases':
        screen = Purchases();
        break;
      default:
        screen = Home();
    }
    updateCurrentRoute(settings.name);
    return MaterialPageRoute(
        builder: (context) => UpdateApp(child: screen), settings: settings);
  };
}
