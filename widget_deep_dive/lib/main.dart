import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() { 
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitDown, 
  //   DeviceOrientation.portraitUp
  // ]);
  runApp(MyApp());
}

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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool _showChart = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


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

  List<Widget> _buildLandscapeContent(
    MediaQueryData mediaQueryData, 
    PreferredSizeWidget appBar,
    Widget transactionListWidget) {
    return [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Show Chart', style: Theme.of(context).textTheme.headline6,),
            Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value: _showChart, 
              onChanged: (value){
                setState(() {
                  _showChart = value;
                });
              })
          ]
        ),
        _showChart ? Container(
            height: (mediaQueryData.size.height - appBar.preferredSize.height - mediaQueryData.padding.top) * 0.7,
            child: Chart(_recentTransaction)
          )
          :
          transactionListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
    MediaQueryData mediaQueryData, 
    PreferredSizeWidget appBar,
    Widget transactionListWidget) {
    return [
        Container(
          height: (mediaQueryData.size.height - appBar.preferredSize.height - mediaQueryData.padding.top) * 0.3,
          child: Chart(_recentTransaction)
        ), transactionListWidget 
    ];
  }

  @override
  Widget build(BuildContext context) {
    print('build() MyHomepageState');
    final mediaQuery = MediaQuery.of(context);
    final isLandScape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget _appBar =  Platform.isIOS 
     ? CupertinoNavigationBar(
       middle: Text('Personal Expenses', style: TextStyle(fontFamily: 'Open Sans'),),
       trailing: Row(
         mainAxisSize: MainAxisSize.min,
         children: [
            GestureDetector(
              child: Icon(CupertinoIcons.add),
              onTap: () => _startAddNewTransaction(context),
            )
          ],),
     )
    
     : AppBar(
        title: Text('Personal Expenses', style: TextStyle(fontFamily: 'Open Sans'),),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: () => _startAddNewTransaction(context))
        ],
    );

    final _transactionListWidget = Container(
      height: (mediaQuery.size.height - _appBar.preferredSize.height - mediaQuery.padding.top) * 0.7,
      child: TransactionList(_transactions, _deleteTransaction)
    );

    final _pageBody = SafeArea(child: SingleChildScrollView(
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if(isLandScape) ... _buildLandscapeContent(mediaQuery, _appBar, _transactionListWidget),
              if(!isLandScape) ... _buildPortraitContent(mediaQuery, _appBar, _transactionListWidget),
              //if(!isLandScape) _transactionListWidget,
            ],
          ),
      )
    );
    
    return Platform.isIOS 
    ? CupertinoPageScaffold(
      navigationBar: _appBar,
      child: _pageBody
      )
    :Scaffold(
      appBar: _appBar,
      body: _pageBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS 
        ? Container() 
        : FloatingActionButton(child: Icon(Icons.add), onPressed: () => _startAddNewTransaction(context),),
    );
  }
}
