import 'package:flutter/material.dart';

class Result extends StatelessWidget {

  final int resultScore;
  final Function resetQuizHandler;

  Result(this.resultScore, this.resetQuizHandler);

  //getter
  String get resultPhrase {
    String resultText = 'You did it!';
    if(resultScore <= 8) {
      resultText = 'You are awesome and innocent!';
    } else if(resultScore <= 12){
      resultText = 'Pretty likeable!';
    } else if(resultScore <= 16) {
      resultText = 'You are ... strange?!';
    } else {
      resultText = 'You are so bad!';
    }
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            resultPhrase, 
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          FlatButton(
            child: Text('Restart Quiz!'), 
            textColor: Colors.blue,
            onPressed: resetQuizHandler,
          )
        ]
      )
    );
  }
}