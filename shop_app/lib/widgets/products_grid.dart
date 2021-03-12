import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final products = context.watch<Products>().items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, 
        childAspectRatio: 3/2, 
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ), 
      // itemBuilder: (ctx, index) => ChangeNotifierProvider(
      //   create: (_) => products[index],
      //   child: ProductItem(
      //     // products[index].id, 
      //     // products[index].title , 
      //     // products[index].imageUrl
      //   ),
      // ),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem()
      ),
    );
  }
}