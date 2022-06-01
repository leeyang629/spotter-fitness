import 'package:flutter/material.dart';

class PersonalGoal extends StatefulWidget {
  final Function selectOption;
  final List<String> savedGoals;

  PersonalGoal(this.selectOption, {this.savedGoals});

  @override
  ComponentState createState() => ComponentState();
}

class ComponentState extends State<PersonalGoal> {
  List<String> personalGoals = [];
  @override
  void initState() {
    super.initState();
    if (widget.savedGoals != null && widget.savedGoals != []) {
      personalGoals = widget.savedGoals;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.run_circle,
            size: MediaQuery.of(context).size.height * 0.3,
          ),
          Text("WHAT'S YOUR PERSONAL GOAL?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(27, 28, 32, 1),
                  fontSize: 28,
                  fontWeight: FontWeight.bold)),
          Padding(
            padding: EdgeInsets.only(top: 12, bottom: 12),
            child: SizedBox(
              height: 20,
              child: Container(
                color: Color.fromRGBO(15, 32, 84, 1),
              ),
            ),
          ),
          Wrap(
            children: [
              option("Lose Weight", "lose_weight"),
              option("Increase Strength", "increase_strength"),
              option("Stay Active", "stay_active"),
              option("Boost Endurance", "boost_endurance"),
              option("Improve Flexibility", "improve_flexibility"),
              option(
                "Tone Muscle",
                "tone_musle",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget option(String text, String value) {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 2 - 30,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              style: ButtonStyle(
                  backgroundColor: personalGoals.indexOf(value) > -1
                      ? MaterialStateProperty.all<Color>(
                          Color.fromRGBO(249, 196, 17, 1))
                      : MaterialStateProperty.all<Color>(
                          Color.fromRGBO(234, 234, 235, 1))),
              clipBehavior: Clip.hardEdge,
              onPressed: () {
                final index = personalGoals.indexOf(value);
                if (index > -1) {
                  setState(() {
                    personalGoals.removeAt(index);
                  });
                } else {
                  setState(() {
                    personalGoals.add(value);
                  });
                }
                widget.selectOption(personalGoals);
              },
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(27, 28, 32, 1),
                    fontSize: 24,
                  ))),
        ));
  }
}
