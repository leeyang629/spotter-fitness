import 'package:flutter/material.dart';
import 'package:spotter/Components/screens/profile_setup/gym_owner/questions_data.dart';
import 'package:spotter/Components/screens/profile_setup/common/question_components.dart';
import 'package:spotter/utils/utils.dart';

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
          // mainAxisAlignment: MainAxisAlignment.center,
          children: questions
              .asMap()
              .entries
              .where((entry) => entry.value['page'] == widget.index)
              .toList()
              .map((entry) {
            var question = entry.value;
            int key = entry.key;
            if (question['page'] == widget.index) {
              final savedVal = question["other"]
                  ? isNotEmpty(widget.onboardData["otherInformation"])
                      ? widget.onboardData["otherInformation"]
                          [question["attribute"]]
                      : null
                  : widget.onboardData[question["attribute"]];

              switch (question["type"]) {
                case "dropDown":
                  return QuestionWithDropDown(
                      key,
                      question["text"],
                      question["values"],
                      (String value) => {widget.changeHandler(key, value)},
                      savedVal: savedVal);
                case "radioBtn":
                  return QuestionWithRadioBtn(
                      key,
                      question["text"],
                      question["values"],
                      question["axis"],
                      (String value) => {widget.changeHandler(key, value)},
                      savedVal: savedVal);
                case "radioBtnWithText":
                  return new QuestionWithRadioBtnAndText(
                      key,
                      question["text"],
                      question["values"],
                      question["axis"],
                      (String value) => {widget.changeHandler(key, value)},
                      savedVal: new Map<String, dynamic>.from(
                          widget.onboardData[question["attribute"]] ?? {}));
                case "text":
                  return new QuestionWithText(key, question["text"],
                      (String value) => {widget.changeHandler(key, value)},
                      maxLines: question["maxLines"], savedVal: savedVal);
                case "selectStrips":
                  return QuestionWithStripSelect(
                      key,
                      question["text"],
                      question["values"],
                      (dynamic value) => {widget.changeHandler(key, value)},
                      savedVal: (savedVal ?? []).cast<String>());
                case "iconStrips":
                  return IconStripSelect(
                      key,
                      question["text"],
                      question["values"],
                      (dynamic value) => {widget.changeHandler(key, value)},
                      savedVal: (savedVal ?? []).cast<String>());
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
