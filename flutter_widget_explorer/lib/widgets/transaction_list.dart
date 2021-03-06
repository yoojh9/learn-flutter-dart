import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {

  final List<Transaction> transactions;
  final Function deleteTransaction;

  TransactionList(this.transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return  Container(
        height: 450,
        child: transactions.isEmpty
        ? Column(
          children:[
            Text('No transactions added yet!', style: Theme.of(context).textTheme.headline6,),
            SizedBox(height: 10,),
            Container(
              height: 200,
              child: Image.asset('assets/images/waiting.png', fit: BoxFit.cover)
            )
          ]
        )
        : ListView.builder(
            itemBuilder: (ctx, index){
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical:0, horizontal: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30, 
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: FittedBox(
                        child: Text('\$${transactions[index].amount}')
                      ),
                    )
                  ),
                  title: Text(transactions[index].title, style: Theme.of(context).textTheme.headline6,),
                  subtitle: Text(DateFormat.yMMMd().format(transactions[index].date)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),  
                    color: Theme.of(context).errorColor, 
                    onPressed: () => deleteTransaction(transactions[index].id)
                    ),
                ),
              );
            },
            itemCount: transactions.length,
          )
    );
  }
}