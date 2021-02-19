import 'package:flutter/material.dart';
import 'question.dart';

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
      'what\'s your favorite color?', 
      'what\'s your favorite animal?',
      'what\'s your favorite food?'
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My First App')),
          body: Column(children: [
            Question(questions[_questionIndex]),
            RaisedButton(child: Text('Answer 1'), onPressed: _answerQuestion,),  // pass pointer to answerQuestion method
            RaisedButton(child: Text('Answer 1'), onPressed: () => print('Answer 2 chosen!'),),
            RaisedButton(child: Text('Answer 1'), onPressed: () {
              print('Answer 3 chosen');              
            },),
          ],) 
      ),
    );
  }
}