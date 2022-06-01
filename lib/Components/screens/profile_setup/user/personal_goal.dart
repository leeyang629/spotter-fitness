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
  final List<String> entries = <String>['Lose Weight',
    'Increase Strength', 'Stay Active', 'Boost Endurance',
    'Improve Flexibility','Tone Muscles'];
  List<bool> _checkedValues = <bool>[false, false, false, false, false,false];
  final List<int> colorCodes = <int>[600, 500, 100, 200];
  @override
  void initState() {
    super.initState();
    if (widget.savedGoals != null && widget.savedGoals != []) {
      personalGoals = widget.savedGoals;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text("What is your personal goal?",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromRGBO(210, 184, 149, 1),
                fontSize: 24)),
        Padding(
          padding: EdgeInsets.only(top: 12, bottom: 12),
          child: SizedBox(
            height: 10,
            child: Container(
            ),
          ),
        ),
        Expanded(
          child:
          ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                              // color: Colors.amber[colorCodes[index]],
                              child:
                              Text('${entries[index]}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(210, 184, 149, 1)
                                  )
                              ),
                            )
                        ),
                        Checkbox(
                          tristate: true,
                          value: _checkedValues[index],
                          shape: CircleBorder(),
                          side: BorderSide(color: Color.fromRGBO(210, 184, 149, 1)),
                          onChanged: (bool newValue){
                            setState(() {
                              _checkedValues[index] = !_checkedValues[index];
                            });
                          },
                          activeColor: Colors.transparent,
                        ),  // onChanged: setState()
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: _checkedValues[index]?Color.fromRGBO(210, 184, 149, 0.3):Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                  );

              }
          ),
        )
      ],
    );
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
