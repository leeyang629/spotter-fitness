import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';

class GenderSelect extends StatefulWidget {
  final String gender;
  final Function(String) changeGender;
  GenderSelect(this.gender, this.changeGender);

  @override
  ComponentState createState() => ComponentState();
}

class ComponentState extends State<GenderSelect> {
  @override
  Widget build(BuildContext context) {
    print(widget.gender);
    return Container(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          genderComponent('male', 'assets/images/male_new.svg'),
          Text(
            "MALE",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromRGBO(210, 184, 149, 1),
                fontSize: 16),
          ),
          genderComponent("female", "assets/images/female_new.svg"),
          Text(
            "FEMALE",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromRGBO(210, 184, 149, 1),
                fontSize: 16),
          ),
          genderComponent("none", "assets/images/no_gender.svg"),
          Text(
            "OTHER",
            textAlign: TextAlign.center,

            style: TextStyle(
                color: Color.fromRGBO(210, 184, 149, 1),
                fontSize: 16),
          ),
        ],
      ),
    ));
  }

  Widget genderComponent(String genderVal, String svgPath) => Container(
      height: MediaQuery.of(context).size.height * 0.2,
      child: GestureDetector(
        onTap: () {
          widget.changeGender(genderVal);
        },
        child: Center(
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: widget.gender == genderVal
                    ? Color.fromRGBO(175, 136, 8, 1)
                    : Colors.transparent,
                shape: BoxShape.circle),
            child: SvgPicture.asset(
              svgPath,
              fit: BoxFit.fitHeight,
              // height: MediaQuery.of(context).size.height * 0.2 - 8,
            ),
          ),
        ),
      ));
}
