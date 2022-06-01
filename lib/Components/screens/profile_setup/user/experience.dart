import 'package:flutter/material.dart';

class Experience extends StatefulWidget {
  final String optionSelected;
  final Function selectOption;

  Experience(this.optionSelected, this.selectOption);

  @override
  ComponentState createState() => ComponentState();
}

class ComponentState extends State<Experience> {
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
