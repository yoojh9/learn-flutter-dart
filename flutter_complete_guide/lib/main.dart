import 'package:flutter/material.dart';
import './question.dart';
import './answer.dart';

// void main(){
//   runApp(MyApp());
// }

void main() => runApp(MyApp()); // only one expression

// statelessWidget -> statefulWidget : refactoring 이용 (code -> keybord shorcut -> refactoring 검색)

/**
 * can be rebuild
 */
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}


/**
 * persistent
 */
class _MyAppState extends State<MyApp> {
  var _questionIndex = 0;

  void _answerQuestion() {
    setState(() {
      _questionIndex++;
    });
    print(_questionIndex);
  }

  @override
  Widget build(BuildContext context) {
    var questions = [
      {
        'questionText': 'What\'s your favorite color?', 
        'answers': [
          'Black', 'Red', 'Green', 'White'
        ],
      },
      {
        'questionText': 'What\'s your favorite animal?', 
        'answers': [
          'Rabbit', 'Snake', 'Elephant', 'Lion'
        ],
      },
      {
        'questionText': 'Who\'s your favorite instuctor?', 
        'answers': [
          'Max', 'Max', 'Max', 'Max'
        ],
      },
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My First App')),
          body: Column(children: [
            Question(
              questions[_questionIndex]['questionText']
            ),
            ...(questions[_questionIndex]['answers'] as List<String>).map((answer) {
              return Answer(_answerQuestion, answer);
            }).toList()
          ],) 
      ),
    );
  }
}