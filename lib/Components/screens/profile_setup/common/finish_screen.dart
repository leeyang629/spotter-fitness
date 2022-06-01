import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spotter/Components/common/dialog.dart';
import 'package:spotter/Components/screens/user_profile/model.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/core/http.dart';
import 'package:spotter/core/storage.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:spotter/Components/screens/profile_setup/common/bottom_section.dart';

class Finish extends StatefulWidget {
  final Function enableButton;
  final Map<String, dynamic> responseBody;
  Finish(this.enableButton, this.responseBody);
  @override
  _Onboarding4State createState() => _Onboarding4State();
}

class _Onboarding4State extends State<Finish> with TickerProviderStateMixin {
  AnimationController _controller;
  bool completed = false;
  final SecureStorage storage = SecureStorage();

  @override
  void initState() {
    super.initState();
    if (widget.responseBody["register"]) {
      setState(() {
        completed = true;
      });
    }
    else
    {
      Future.delayed(Duration(milliseconds: 500), callOnboardApi);
    }
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _controller.addListener(() {
      if (_controller.status == AnimationStatus.completed) {
        widget.enableButton();
        setState(() {
          completed = true;
        });
      }
    });
    // _controller.forward();
  }

  Future<dynamic> callOnboardApi() async {
    final persona = Provider.of<AppState>(context, listen: false).userPersona;
    if (persona == "user" || persona == "trainer") {
      await userOnboarding(persona);
    }
    if (persona == "owner") {
      _controller.forward();
    }
  }

  Future<dynamic> userOnboarding(String persona) async {
    final api = HttpClient(productionApiUrls.user);
    try {
      Provider.of<AppState>(context, listen: false).enableSpinner();
      api.headers["content-type"] = "application/json";
      final result = await api.post(
          "/api/v1/users/onboard_user_information",
          {
            "data": widget.responseBody["data"],
            "organisationPermalink": widget.responseBody["gym"]
          },
          withAuthHeaders: true);
      if (result["statusCode"] == 200) {
        print(result);
        if (persona == "user") {
          Provider.of<AppState>(context, listen: false).setOnboardData(
              UserDetails.fromJson(widget.responseBody["data"]));
        }
        Provider.of<AppState>(context, listen: false).disableSpinner();
        _controller.forward();
      }
    } catch (e) {
      Provider.of<AppState>(context, listen: false).disableSpinner();
      print("error");
      print(e);
      errorDialog(context, () {
        callOnboardApi();
        Navigator.pop(context);
      }, "Onboarding failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            SvgPicture.asset(
              "assets/images/spotter_text.svg",
              width: 300,
            ),
            AnimatedOpacity(
              opacity: completed ? 1 : 0,
              duration: Duration(milliseconds: 300),
              child: Text("YOU'RE ALL SET!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Lottie.asset('assets/lottie/correct_mark.json',
                width: 100,
                height: 200,
                controller: _controller, onLoaded: (composition) {
              _controller..duration = composition.duration;
            })
          ],
        ),
        finish(completed, finishiHandler)
      ],
    );
  }

  void finishiHandler() {
    if (completed) {
      String persona =
          Provider.of<AppState>(context, listen: false).userPersona;
      if (persona == "user") {
        Navigator.pushReplacementNamed(context, '/trainers_list');
      } else if (persona == "trainer") {
        Navigator.pushReplacementNamed(context, '/trainer_dashboard');
      } else if (persona == "owner") {
        Navigator.pushReplacementNamed(context, '/gym_dashboard');
      }
    }
  }
}
