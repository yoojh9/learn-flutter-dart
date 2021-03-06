import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './adaptive_button.dart';

class NewTransaction extends StatefulWidget {

  final Function addNewTransaction;

  NewTransaction(this.addNewTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData(){
    if(_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if(enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    
    widget.addNewTransaction(
      enteredTitle,
      enteredAmount,
      _selectedDate
    );
    
    Navigator.of(context).pop();
  }


  void _presentDatePicker() {
    // Flutter built int
    showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2021), 
      lastDate: DateTime.now()
    ).then((pickedDate){
      if(pickedDate == null){ // when user pressed cancel,
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
    print('....');
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            children:[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData,
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Text(_selectedDate == null ? 'No Date Chosen!' : 'Picked Date : ${DateFormat.yMMMd().format(_selectedDate)}')
                    ),
                    Flexible(
                      flex: 7,
                      child: AdaptiveButton('Choose Date', _presentDatePicker)  
                    )
                  ],),
                  
              ),
              RaisedButton(
                child: Text('Add Transaction'), 
                textColor: Theme.of(context).textTheme.button.color,
                color: Theme.of(context).primaryColor,
                onPressed: _submitData,
              )
            ]
          ),
        ),
      ),
    );
  }
}