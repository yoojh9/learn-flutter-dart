import 'package:flutter/material.dart';
import './new_transaction.dart';
import './transaction_list.dart';
import '../models/transaction.dart';

class UserTransaction extends StatefulWidget {
  @override
  _UserTransactionState createState() => _UserTransactionState();

}

// private class
class _UserTransactionState extends State<UserTransaction> {
  final List<Transaction> _transactions = [
    Transaction(id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
    Transaction(id: 't2', title: 'Weekly Groceries', amount: 16.53, date: DateTime.now()),
  ];

  // private method
  void _addNewTransaction(String txTitle, double txAmount){
    final newTransaction = Transaction(title: txTitle, amount: txAmount, date: DateTime.now(), id: DateTime.now().toString());
    
    setState(() {
      _transactions.add(newTransaction);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          NewTransaction(_addNewTransaction),
          TransactionList(_transactions)
      ],
    );
  }
}