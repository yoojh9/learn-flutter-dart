# State Management

## 1. Grid & Item Widget

### 1) GridView
The item builder defines how every grid item is built, how every grid cell should be built.

The **gridDelegate** allows us to define how the grid generally should be structured, so how many coulmns it should have.
and we set that by providing a SliverGridDelegate and then I'll use with FixedCrossAxisCount which means I can define that I want to have a certain amount of columns and it will simply squeeze the items onto the screen so that this criteria is met.
The alternative would be the SliverGridDelegateWithFixedExtent which we used earlier, we can define how wide every grid item should be and it will then create as many columns as it can for the given device size.

```
[product_overview_screen.dart]

GridView.builder(
    padding: const EdgeInsets.all(10.0),
    itemCount: loadedProducts.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, 
        childAspectRatio: 3/2, 
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
    ), 
    itemBuilder: (ctx, index) => ProductItem(
        loadedProducts[index].id, 
        loadedProducts[index].title, 
        loadedProducts[index].title
    ),
),
```

```
[product_item.dart]

 class ProductItem extends StatelessWidget {

   final String id;
   final String title;
   final String imageUrl;

   ProductItem(this.id, this.title, this.imageUrl);

   @override
   Widget build(BuildContext context) {
     return GridTile(
       child: Image.network(imageUrl, fit: BoxFit.cover,),
       footer: GridTileBar(
         leading: IconButton(icon: Icon(Icons.favorite), onPressed: (){}),
         backgroundColor: Colors.black45,
         title: Text(title, textAlign: TextAlign.center,),
         trailing: IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){},),
        ),
     );
   }
 }
```

our goal there will be don't manage all our state in the main.dart file and pass all the state as arugments to other widget.

<br><br>

## 2. Styling & Theming

```
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
    );
  }
}

```

## 3. Adding Navigation to the App
instead of getting or having properties which we get as arguments in the constructor, it would be nice to retrieve arguments from our routing action.
we refer to the product detail screen route name and we can set some arguments.

we always pass data just through constructors, instead now we need a cental state management solution.

<br><br>

## 4. Why State Management? And What is "State"  and "State Management"?
The problem is that in bigger app where we have a lot of widgets, when some child widget needs some data, we typically have to manage the data in our topmost widget, in the MyApp Widget here because different places of the app need the data and therefore, we have to use the common denominator so that we can pass data through the constructors of widgets because that is how we typically distribute values or data.

We pass them as argument to other widgets and that can lead to very long chains.

<image src="./images/problem1.png" width="300">

That's the problem. becuase it can be cumbersome and difficult to pass data through constuctors. 
and it can also impact our application performance becuase if we manage everything in the main.dart file and there in our main widget or in a couple of root widgets, then these widgets rebuild whenver anything data changes and the entire widget tree rebuilds even if only one small child widget somewhere in the tree is really interested in the updated data.

Hence, we need a better way of managing our state.

<br>

### 1) What "State" and "State Management"

when your data changes, something typically changes on the user interface because your user interface reflects your data.
and it's this data we also refer to as state. State is simply data which affects the user interface and which also might change over time.

The user interface is just a function of your data or of your state which means if your data (your state) changes, the user interface changes.

We have **Application-wide state** and we have **widget(Local) state**.

### 2) App-Wide State
App-Wide state as the name suggests affects the entire application or at least large chunks of the app. and for examples would be the authentication status of a user, is the user authenticated. if the user is not authenticated, we typically want to show a totally different app. we want to show a login screen instead of our products but the loaded products themselves could be data that is required in many parts of your app.
So these are pieces of data which you need in many places of your app or which have an impact on the entire app or on large chunks of the app.

### 3) Widget(Local) Sate
on the other hand, Widget or local state is really just states the affects only a widget on its own and does not affect other widgets.
and typical example would be a loading spinner.
This piece of information does probably not affect any other widget but it's important for this widget and what you display in there or when you manage form input, so text input user enters, things like is the data the user entered valid or are these errors in the data the user entered.

<image src="./images/state_management.png" width="700">

<br><br>

## 5. Understanding the "Provider" Package & Approach
The provider pattern which is added by adding a certain package to your app, the provider package. 
The idea is that you have a global, a central store or data container in your app, data provider.
As soon as you added your provider, so this data container to a widget, all child widgets of that widget can listen to that provider but without passing the data through their constuctors instead, they can add a listener with this of context trick by using this inherited widget.

Now the build method for that widget where you attach the listener to or where you added the listener to run whenever the state in that data provider changes but only the build method of that widget.

If the data changes, let's say the list of products we loaded, then we'll not reload or rebuild all widgets we have but instead we would only run the build method in the single product widget because the single product widget is the only widget that set up a listener to our data provider. 

You can have multiple provider in the same app, multiple data container and you can attach them to different or to the same widget and it doesn't have to be the root widget. 

So you could have a cart provider attached to the cart and then you can also have multiple listeners to one and the same provider, which also are then set up on different widgets that needs listener. and all these widgets will rebuild whenever this provider or the data you store in it updates, whenever you update the data stored in that provider, in that container.

<image src="./images/provider.png" width="700">

<br><br>

## 6. Working with provider & Listeners
[provider](https://pub.dev/packages/provider)

you add mixin by adding the with keyword. mixin is a like extending never a class. The core differences is that you simply merge some properties or add some methods into your existing class.

We need to mixin is a ChangeNotify class. ChangeNotifier is basically kind of related to the inherited widget which the provider package uses behind the scenes and inherited the widget while we won't work with it directly it's simply a widget which allows us to establish behind the scenes communication tunnels with the help of the context object which we're getting in every widget.

<br>

### 1) List getter setter
You have to remember that all these object and flutter or the Dart are reference types.
If I would return my items list then I would return a pointer at this object and memory.
That means that anywhere in the code where I get access to my products class, I get that address and therefore I get direct access to this list of items itself in memory. 

```
class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];  // return copy off
  }

  void addProduct(){
    _items.add(value);
    notifyListeners();
  }

}
```

### 2) provider 추가하기
- [provider Example 참고](https://pub.dev/packages/provider/example)

runApp(MyAPp()) 대신 runApp()에 Provider를 추가한다.

```
[main.dart]

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => Products(),)
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
      },
    );
  } 
}


```

### 3) provider 사용하기

```
[products_grid.dart]

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
      itemBuilder: (ctx, index) => ProductItem(
        products[index].id, 
        products[index].title , 
        products[index].imageUrl
      ),
    );
  }
}
```