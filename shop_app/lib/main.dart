import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => Products(),),
      ChangeNotifierProvider(create: (_) => Cart(),),
    ],
    child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch:  Colors.lightBlue,
        accentColor: Colors.amber,
        fontFamily: 'Lato',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProductOverviewScreen(),
      routes: {
        ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        CartScreen.routeName: (ctx) => CartScreen(),
      },
    );
  } 
}
