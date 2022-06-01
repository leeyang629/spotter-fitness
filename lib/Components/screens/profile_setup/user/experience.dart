import 'package:flutter/material.dart';

class Experience extends StatefulWidget {
  final String optionSelected;
  final Function selectOption;
  Experience(this.optionSelected, this.selectOption);

  @override
  ComponentState createState() => ComponentState();
}

class ComponentState extends State<Experience> {
  final List<String> entries = <String>['0-1 days',
    '2-3 days', '4-5 days', '6-7 days'];
  List<bool> _checkedValues = <bool>[false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text("How active are you during the week?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(210, 184, 149, 1),
              fontSize: 24,)),
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
          Text("HOW ACTIVE ARE YOU?",
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              option("I am Sedentary", "sedentary"),
              option("I am active 1-2 days/week", "lightly_active"),
              option("I am active 3-5 days/week", "active"),
              option("I am active 5+ days/week", "very_active"),
            ],
          )
        ],
      ),
    );
  }

  Widget option(String text, String value) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
          style: ButtonStyle(
              backgroundColor: widget.optionSelected == value
                  ? MaterialStateProperty.all<Color>(
                      Color.fromRGBO(249, 196, 17, 1))
                  : MaterialStateProperty.all<Color>(
                      Color.fromRGBO(234, 234, 235, 1))),
          clipBehavior: Clip.hardEdge,
          onPressed: () {
            widget.selectOption(value);
          },
          child: Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(27, 28, 32, 1),
                fontSize: 24,
              ))),
    );
  }
}
