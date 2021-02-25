import 'package:flutter/material.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
            fontFamily: 'Open Sans',
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
          button: TextStyle(color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'Open Sans', 
              fontSize: 20,
              fontWeight: FontWeight.bold
            ), 
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    // Transaction(id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
    // Transaction(id: 't2', title: 'Weekly Groceries', amount: 16.53, date: DateTime.now()),
  ];

  List<Transaction> get _recentTransaction {
    return _transactions.where((tx){
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  // private method
  void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate){
    final newTransaction = Transaction(
      title: txTitle, 
      amount: txAmount, 
      date: chosenDate,
      id: DateTime.now().toString()
    );
    
    setState(() {
      _transactions.add(newTransaction);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((element) => element.id==id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(context: ctx, builder: (_){
      return NewTransaction(_addNewTransaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar =  AppBar(
        title: Text('Personal Expenses', style: TextStyle(fontFamily: 'Open Sans'),),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: () => _startAddNewTransaction(context))
        ],
      );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.3,
                child: Chart(_recentTransaction)
              ),
              Container(
                height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.7,
                child: TransactionList(_transactions, _deleteTransaction)
              )
            ],
          ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add), onPressed: () => _startAddNewTransaction(context),),
    );
  }
}
