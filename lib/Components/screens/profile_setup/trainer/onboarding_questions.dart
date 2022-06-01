import 'package:flutter/material.dart';
import 'package:spotter/Components/screens/profile_setup/trainer/questions_data.dart';
import 'package:spotter/Components/screens/profile_setup/common/question_components.dart';

class OnboardingQuestions extends StatefulWidget {
  final int index;
  final Function changeHandler;
  final Map<String, dynamic> onboardData;
  OnboardingQuestions(this.index, this.changeHandler, this.onboardData);
  @override
  QuestionState createState() => QuestionState();
}

class QuestionState extends State<OnboardingQuestions> {
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: questions
              .asMap()
              .entries
              .where((entry) => entry.value['page'] == widget.index - 1)
              .toList()
              .map((entry) {
            var question = entry.value;
            int key = entry.key;
            if (question['page'] == widget.index - 1) {
              switch (question["type"]) {
                case "dropDown":
                  return new QuestionWithDropDown(
                    key,
                    question["text"],
                    question["values"],
                    (String value) => {widget.changeHandler(key, value)},
                    savedVal: widget.onboardData[question["attribute"]],
                  );
                case "radioBtn":
                  return new QuestionWithRadioBtn(
                      key,
                      question["text"],
                      question["values"],
                      question["axis"],
                      (String value) => {widget.changeHandler(key, value)},
                      savedVal: widget.onboardData[question["attribute"]]);
                case "radioBtnWithText":
                  return new QuestionWithRadioBtnAndText(
                      key,
                      question["text"],
                      question["values"],
                      question["axis"],
                      (String value) => {widget.changeHandler(key, value)},
                      savedVal: new Map<String, dynamic>.from(
                          widget.onboardData[question["attribute"]]));
                case "text":
                  return new QuestionWithText(key, question["text"],
                      (String value) => {widget.changeHandler(key, value)},
                      savedVal: widget.onboardData[question["attribute"]]);
                case "selectStrips":
                  return QuestionWithStripSelect(
                      key,
                      question["text"],
                      question["values"],
                      (dynamic value) => {widget.changeHandler(key, value)},
                      savedVal: widget.onboardData[question["attribute"]]
                          ?.cast<String>());
                default:
                  return Container();
              }
            }
          }).toList(),
        ),
      ),
    );
  }
}
