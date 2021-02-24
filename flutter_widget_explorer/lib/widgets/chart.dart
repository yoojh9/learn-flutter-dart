import 'package:flutter/material.dart';
import '../models/transaction.dart';
import './chart_bar.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {

  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupTransactionValue {
    // generate: List를 생성해줌
    return List.generate(7, (index) { 
      final weekDay = DateTime.now().subtract(Duration(days: index),);

      double totalSum = 0.0; 
      
      for(var i=0; i<recentTransactions.length; i++){
        if (recentTransactions[i].date.day == weekDay.day && 
            recentTransactions[i].date.month == weekDay.month && 
            recentTransactions[i].date.year == weekDay.year){
              totalSum += recentTransactions[i].amount;
        }
        
      }
      
      print(DateFormat.E().format(weekDay));
      print(totalSum);

      return {'day': DateFormat.E().format(weekDay), 'amount': totalSum};
    
    });
  }

  double get totalSpending {
    return groupTransactionValue.fold(0.0, (sum, item) => sum + item['amount']);
  }

  @override
  Widget build(BuildContext context) {
    print(groupTransactionValue.toString());
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Row(
        children: groupTransactionValue.map((data) => 
          ChartBar(data['day'], data['amount'], totalSpending == 0.0 ? 0.0 : (data['amount'] as double) / totalSpending)
        ).toList()
      ),
    );
  }
}