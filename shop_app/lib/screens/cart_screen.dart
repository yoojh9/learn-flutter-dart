import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    // I want to rebuild when something changes
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: Column(children: [
        Card(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: EdgeInsets.all(8), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: TextStyle(fontSize: 20),),
                SizedBox(width: 10),
                Chip(
                  label: Text('${cart.totalAmount}', style: TextStyle(color: Theme.of(context).primaryTextTheme.headline6.color),), 
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                TextButton(
                  onPressed: (){
                    Provider.of<Orders>(context, listen: false)
                      .addOrder(cart.items.values.toList(), cart.totalAmount);
                    cart.clear();
                  }, 
                  child: Text('ORDER NOW', style: TextStyle(color: Theme.of(context).primaryColor),)
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 10,),
        Expanded(
          child: ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (ctx, index) => CartItem(
                id: cart.items.values.toList()[index].id,
                productId: cart.items.keys.toList()[index],
                title: cart.items.values.toList()[index].title, 
                quantity: cart.items.values.toList()[index].quantity, 
                price: cart.items.values.toList()[index].price
            ) 
          )
        )
      ],),
    );
  }
}