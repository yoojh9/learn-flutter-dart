import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  final String questionText;  // external data

  Question(this.questionText);

  @override
  Widget build(BuildContext context) {

    return Text(questionText);
  }
}