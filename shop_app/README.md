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

<br><br>

## 7. Inheritance("extends") vs Mixins("with")
The idea behind a mixin is that you can share methods and properties with multiple classes but logically, you have less of a strong connection.
mixin is like a utilicy function provider which we can use to mix certain features into this class.

some programming languages support multiple parents, Dart is not one of them, you can only have one parent class.
however, with mixins you can add as many mixins as you want. So you can add multiple mixins to the same class and all their properties and methods will be merged together in the class.

So really think of mixins as utility functionality providers wheras when you use inheritance, you really have a strong logical dependency between the two classes.

```
mixin Agility {
    var speed = 10;

    void sitDown() {
        print('Sitting down..');
    }
}

class Malmmal {
    void breath(){
        print('Breath in... breath out...);
    }
}

class Person extends Mammal with Agility {
    String name;
    int age;

    Person(this.name, this.age);

    void main(){
        final pers = Person('Max', 30);
        print(pers.name);
        pers.breath();
        print(pers.speed)
        pers.sitDown();
    }
}
```

<br><br>

## 8. Providing non-Objects
Typically, when working with the Provider package, you provide objects based on your own custom classes.

This makes sense because you can implement the **ChangeNotifier** mixin in your classes to to then trigger **notifyListeners()** 
whenever you want to update all places in your app that listen to your data.

<br><br>

## 9. Listening in Different Places & Ways

the **listen** argument which you can set to false. 
the default is true then the build method of the widget in which you're using provider of will rerun whenever the provided object changed. 
So if this would change or the data would change, if we call notifyListener(), then all widgets that use provider of would rebuild.

with lister false, this widget will not rebuild if notifyListener is called. becuase it's not set up as an active listener and that is something you should do if you only need data one time, you want to get data from your global data storage but you're not interested in updates, then you don't need to listen.


```
final product = Provider.of<Products>(context, listen: false).findById(productId);
```

<br><br>

## 10. Using Nested Models & Providers

아래처럼 main.dart에 provider를 등록하면 global로 접근할 수 있다.
So the entire app can listen to changes in products because we need products in different place. (products)

```
[main.dart]
void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => Products(),)
    ],
    child: MyApp(),
    ),
  );
}
```

Now my single product is actually really only needed in every product item list. 
for the individual product item is that's a bit different. 

in product_grid where I'm providing a product for this products item and a new product is provided for every different product item which is rendered.
So for every grid tile because we're repeating this code for all the product so does reruns for all the products we have.

There is actually one little problem you should be aware of when working with nested provider, when you're using it in a list or in a grid where flatter removes items when they leave the screen and re-adds them when they reentered the screen in such situation what actually happens is that the widget itself is reused by flutter and just the data that's attached to it changes.

So flutter recycles the same widget it doesn't destroy it and recreate it which would work fine with our nested provider.
Therfore the more items you have in your list as soon as you have items that are not visible all the time.

 
```
[product_grid.dart]

class ProductsGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, 
        childAspectRatio: 3/2, 
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ), 
      itemBuilder: (ctx, index) => ChangeNotifierProvider(
        create: (_) => products[index],
        child: ProductItem(),
      ) 
    );
  }
}
```

I want to make sure that when we tap that favoriate button we switched a favorite status of a single product for that and our product provider follow up there in the provider's folder.

```
[product.dart]

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite; // will be changable

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus(){
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
```

to let all listener know we need to call nofity listners like setState(), in the provider package you let listening which it's know that something changed and they should rebuild. it's the equivalent to setState().


Favorite Icon 버튼의 onTap()에서 product.toggleFavoriteStatus를 호출한다. 메소드가 호출되면 product.isFavorite 값이 변경되고, 그에 따라 Icon이 바뀌는 것을 확인할 수 있다.
그러나 listen:false로 provider를 등록하면 버튼이 변경되지 않는다.
That means that when is favorite changes here it will still change behind the scene, but notifyListener will not reach this build method in this widget.
so this product here will not received as updated is favorite status. Therefore a build will not rerun and therefore will not see the new icon.

```
[product_item.dart]

 class ProductItem extends StatelessWidget {

   @override
   Widget build(BuildContext context) {
     final product = Provider.of<Product>(context, listen: false);

     return ClipRRect(
       borderRadius: BorderRadius.circular(10),
       child: GridTile(
         child: GestureDetector(
           onTap: (){
             Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: product.id);
           },
           child: Image.network(product.imageUrl, fit: BoxFit.cover,)
         ),
         footer: GridTileBar(
          backgroundColor: Colors.black38,
           leading: IconButton(
             icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border), 
             color: Theme.of(context).accentColor,
             onPressed: product.toggleFavoriteStatus,
           ),
           title: Text(product.title, textAlign: TextAlign.center,),
           trailing: IconButton(
             icon: Icon(Icons.shopping_cart), 
             color: Theme.of(context).accentColor,
             onPressed: (){},
            ),
          ),
       ),
     );
   }
 }
```

<br><br>

## 11. Exploring Alternative Provider Syntaxes

Provider는 ChangeNotifierProvider().create()와 ChangeNotifierProvider.value() 두가지 방식을 사용할 수 있음

```
// 1)
ChangeNotifierProvider(
    create: (_) => products[index],
    child: ProductItem(
        products[index].id, 
        products[index].title , 
        products[index].imageUrl
    ),
),

// 2)
ChangeNotifierProvider.value(
    value: products[index],
    child: ProductItem()
),

```

### 1) Provider constructor

To expose a newly created object, use the default constructor of a provider. Do not use the **.value** constructor if you want to create an object, or you may otherwise have undesired side-effects.

- DO create a new object inside create.

```
Provider(
  create: (_) => MyModel(),
  child: ...
)
```

- DON'T use **Provider.value** to create your object.

```
ChangeNotifierProvider.value(
  value: MyModel(),
  child: ...
)
```

- DON'T create your object from variables that can change over the time. In such a situation, your object would never be updated when the value changes.

```
int count;

Provider(
  create: (_) => MyModel(count),
  child: ...
)
```

### 2) Reusing an existing object instance
If your already have an object instance and want to expose it, you should use the **.value** constuctor of a provider.

- DO use changeNotifierProvider.value to provide an existing ChangeNotifier

```
MyChangeNotifier variable;

ChangeNotifierProvider.value(
  value: variable,
  child: ...
)
```

- DON'T reuse an existing ChangeNotifier using the default constuctor

```
MyChangeNotifier variable;

ChangeNotifierProvider(
  create: (_) => variable,
  child: ...
)
```

### 3) In Shop-App Project
Whenever you instantiate a class so whenever you create a new object based on a class, If you do that to provide object to the changeNotifier our provider you should use the create() method. 
Whenever you reuse an existing object like we're doing it integrate where we cycle through a list of products which already all exist It's recommended that you use that value approach.

```
[main.dart]
void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => Products(),)
    ],
    child: MyApp(),
    ),
  );
}

[products_grid.dart]
class ProductsGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, 
        childAspectRatio: 3/2, 
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ), 
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem()
      ),
    );
  }
}
```

<br><br>

## 12. Using "Consumer" instead of "Provider.of"
There is another alernative syntax which I want to show you that's related to how you listen to changes. 
There is another way which is totally equal which you could also use. 
You could wrap the Consumer widget, to be available you need to import your provider package.
Consumer actually does not take just a child but actually a builder.

```
[product_item.dart]

 class ProductItem extends StatelessWidget {

   @override
   Widget build(BuildContext context) {
     return Consumer<Product>(
        builder: (ctx, product, child) => ClipRRect(
         borderRadius: BorderRadius.circular(10),
         child: GridTile(
           child: GestureDetector(
             onTap: (){
               Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: product.id);
             },
             child: Image.network(product.imageUrl, fit: BoxFit.cover,)
           ),
           footer: GridTileBar(
            backgroundColor: Colors.black38,
             leading: IconButton(
               icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border), 
               color: Theme.of(context).accentColor,
               onPressed: product.toggleFavoriteStatus,
             ),
             title: Text(product.title, textAlign: TextAlign.center,),
             trailing: IconButton(
               icon: Icon(Icons.shopping_cart), 
               color: Theme.of(context).accentColor,
               onPressed: (){},
              ),
            ),
         ),
       ),
     );
   }
 }
```

when you use provider.of then the whole build method will rerun whenever that data changes. with clever widget splitting, you can split your widgets such that this isn't a problem because you want to run the entire build method when something changes.
but you could always have a case where you only want to run a subpart of your widgets tree when some data changes and then you could only wrap the subpart of the widget tree that depends on your product data with that listener. 

<br>

### 1) 변경되는 데이터 Widget만 바뀌도록 코드 수정

favorite IconButton을 Tap 하더라도 'product rebuild' print문이 찍히지 않는다.
단, product provider의 listen을 true로 전달하면 favorite 버튼이 tap 될 때마다 rebuild 된다.

```
 class ProductItem extends StatelessWidget {

   @override
   Widget build(BuildContext context) {
     final product = Provider.of<Product>(context, listen: false);
     print('product rebuild');
      
     return ClipRRect(
         borderRadius: BorderRadius.circular(10),
         child: GridTile(
           child: GestureDetector(
             onTap: (){
               Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: product.id);
             },
             child: Image.network(product.imageUrl, fit: BoxFit.cover,)
           ),
           footer: GridTileBar(
            backgroundColor: Colors.black38,
             leading: Consumer<Product>(
                builder: (ctx, product, child) => IconButton(
                  icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border), 
                  color: Theme.of(context).accentColor,
                  onPressed: product.toggleFavoriteStatus,
                ),
             ),
             title: Text(product.title, textAlign: TextAlign.center,),
             trailing: IconButton(
               icon: Icon(Icons.shopping_cart), 
               color: Theme.of(context).accentColor,
               onPressed: (){},
              ),
            ),
         ),
       );
   }
 }
```


<br><br>

## 13. Local State vs App-wide State
Why do we not use a stateful widget? 
we're now using the provider to manage whether our product is a favorite or not. but we only need that information to change icon.
Now since I change that icon in my product_item widget, we could also turn this into a stateful widget. 
and yes, this would be absolutely the right thing to do if you have some state, some data which only affects this widget. 

<image src='./images/state.png' width='700'>

**Widget(lcoal)State** is a state which only affects a single widget. if you only want to switch the icon on a button in a widget, then you would typically manage that state only in that widget and therefore you would always use a stateful widget. Don't use provider or a provided class if you only want to change how something is displayed inside of a widget.

of course, it means that the information about whether a product is a favorite or not does not just matter to the product item but to the entire app or at least to a significant part of that app.


```
[products.dart]

  var _showFavoritesOnly = false;

  List<Product> get items {
    if(_showFavoritesOnly){
      return _items.where((item) => item.isFavorite).toList();
    }
    return [..._items];  // return copy off
  }

  Product findById(String id){
    return _items.firstWhere((item) => item.id == id);
  }

  void addProduct(value){
    _items.add(value);
    notifyListeners();
  }

  void showFavoritesOnly() {
    _showFavoritesOnly = true;
    notifyListeners();
  }

  void showAll(){
    _showFavoritesOnly = false;
    notifyListeners();
  }
  

```

```
[product_overview_screen.dart]

class ProductOverviewScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<Products>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              if(selectedValue == FilterOptions.Favorites) {
                productsContainer.showFavoritesOnly();
              } else {
                productsContainer.showAll();
              }
            },
            icon: Icon(Icons.more_vert), 
              itemBuilder: (_) => [
              PopupMenuItem(child: Text('Only Favorites'), value: FilterOptions.Favorites,),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.All,)
            ]
          )
        ],
      ),
      body: ProductsGrid(),
    );
  }
}

```

이렇게 하면 오류 없이 작동하지만, products provider를 사용하는 모든 위젯에 _showFavoritesOnly 필터가 적용된다는 것이다. _showFavoritesOnly는 products_overview_screen.dart에서만  사용된다.

### 1) Turn into a StatefulWidget. (Local State)
it's really an information that belongs to a sigle widget and not into the global app-wide state. This actually is not the approach I want to use.
Instead, the better option would be to turn into a stateful widget

we can now pass that down to the products_grid like **ProductsGrid(_showOnlyFavorites)**
in products_grid.dart we use this with setState() so that the UI is rebuilt when you change it.

```
[products_overview_screen.dart]

class ProductOverviewScreen extends StatefulWidget {

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
 var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<Products>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if(selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;   
                } else {
                  _showOnlyFavorites = false;   
                } 
              });
            },
            icon: Icon(Icons.more_vert), 
              itemBuilder: (_) => [
              PopupMenuItem(child: Text('Only Favorites'), value: FilterOptions.Favorites,),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.All,)
            ]
          )
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}

```

```
[products_grid.dart]

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;

  ProductsGrid(this.showFavorites);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavorites ? productsData.favoriteItems : productsData.items;
  }
}
```