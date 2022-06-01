import 'package:flutter/material.dart';

class QuestionComponent extends StatelessWidget {
  final String question;

  QuestionComponent(this.question);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(
      question,
      style: TextStyle(fontSize: 16.0),
    ));
  }
}
