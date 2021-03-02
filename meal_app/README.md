# Navigation & Multiple Screens [Meals App]

## 1. Starting with the App 

### 1) SliverGridDelegateWithMaxCrossAxisExtent
Sliver in Flutter are really just scrollable areas on the screen, and grid just like the ListView, is scrollable as a default. 
**gridDelegate** that simply means that for the grid, this takes care about structuring, layouting the grid, so this task of providing a layout is delegated away to this class.
and **WithMaxCrossAxisExtent** simply means that this is a preconfigured class which allows us to define a maximum width for each grid item and it will automatically create as many columns as we can fit items with that provided width next to each other.

```
[category_screen.dart]

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView(
      children: [],
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20
        ), 
      
    );
  }
}
```

I'll use 200 pixels and not it really depends on the device size how many columns we'll get in that grid. 

we can also define a **childAspectRatio** to defind how the items should be sized regarding their height and width relation.
I want to have a 3 by 2 relation, so for 200 width, I want to have 300 height in the end.
and you can add some spacing **crossAxisSpacing** of 20 and some **mainAxisSpacing** of 20 which simply means how much distance is between our columns and rows in that grid.

<br><br>

## 2. Registering a Screen as the Main Screen
**home** argument in main.dart which you provide and that points at the widget which should be loaded as the first screen in your application.

<br><br>

## 3. Styling & Theming

```
[main.dart]
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: ThemeData.light().textTheme.copyWith(
          bodyText1: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
          bodyText2: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
          headline6: TextStyle(fontSize: 20, fontFamily: 'RotoboCondensed', fontWeight: FontWeight,bold),
        )
      ),
      home: CategoriesScreen(),
    );
  }
}

```

<br><br>

## 4. Navigating to a new page

### 1) InkWell
InkWell is basically a GestureDetector which also fires off a ripple effect, So this Material Design effect you have when you tap something, where you have these waves comming out of the point where you tapped it.

InkWell borderRadius에 BorderRadius.circular(15)를 주면, Container에 지정한 borderRadius.circular(15)에 알맞게 효과가 적용된다.
So the BorderRadius for the InkWell should match the BorderRadius down there for the container.

```
[category_item.dart]
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Text(title, style: Theme.of(context).textTheme.headline6,),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.7),
              color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15)
        )
      ),
    );
  }
}
```

<br>

### 2) Navigator
Navigator is class built into Flutter which helps you with navigating between your screens.
Like Theme or mediaQuery, it needs to be connected to the context because you might rememeber that context is this object which has information about this widget and its position in the widget tree. 

<br>

### 3) Navigation in Flutter Apps
we typically do this by managing these pages as a stack of pages.
What's a stack? A stack basically is a list. The idea simply is that when we go to the product page, we actually add this product page to the list and when we go back from it, we remove it from the list.

and you can imagine this list as being in a three-dimensional space where you always see the last or the topmost item of that stack, so the topmost page is visible.

<image src="./images/stack.png" width="600">

**pushReplacement()** means that instead of adding a page on the stack or on top of the stack, you add it but you remove the page below it. so you still only have one page in your list then instead of two and that means that you won't be able to go back from that new page becuase you deleted the page you were coming from.

**push()** with adding MaterialPageRoute or CupertinoPageRoute. These are class but you have to instantiate by adding parentheses. We need MaterialPageRoute as a wrapper to handle things like the animation from the old page to the new page. 

```
[category_item.dart]
  void selectCategory(BuildContext ctx){
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
      return CategoryMealsScreen();
    }));
  }
```

<br><br>

## 5. Using Named Routes & Passing Data with Named Routes
for that the main.dart file, you can set up **routes** argument. The route table takes a map where you have string keys which identify a route. And a route is really just a screen and the value after the colon your creating function for that screen. 

```
[main.dart]

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      ...
      home: CategoriesScreen(),
      routes: {
        '/category-meals': (ctx) => CategoryMealsScreen()
      },
    );
  }
}

```

Tankfully though, Flutter also has a different mechanism of passing data between routes. Besides using the constuctor of the screen we're loading, it also has its own messaging system you could say, its own system for passing data. 

일단, 기존 CategoryMealsScreen 클래스의 변수와 생성자 코드를 주석처리한다.

category_item.dart 파일에서 MaterialPageRoute 대신 pushNamed를 사용한다.

```
[category_item.dart]
  void selectCategory(BuildContext ctx){
    Navigator.of(ctx).pushNamed(
      '/category-meals', 
      arguments:  {'id': id, 'title': title}
    );
  }
```

<br>

How could we now extract the data in a CategoryMealsScreen? 

```
class CategoryMealsScreen extends StatelessWidget {
  // final String categoryId;
  // final String categoryTitle;
  
  // CategoryMealsScreen(this.categoryId, this.categoryTitle);

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
    final categoryTitle = routeArgs['title'];
    final categoryId = routeArgs['id'];
    
    return Scaffold(
      appBar: AppBar(title: Text(categoryTitle)),
      body: Center(
        child: Text(categoryTitle),
      )
    );
  }
}
```


<br><br>

## 6. Diving Deeper into Named Routes
'home' always also has an automatically named route which is just \'\/\'.
and remove the home argument. 

```
[main.dart]

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      ...
      // home: CategoriesScreen(),
      routes: {
        '/': (ctx) => CategoriesScreen(),
        '/category-meals': (ctx) => CategoryMealsScreen()
      },
    );
  }
}

```

you can also add an initialRoute argument to your MaterialApp and the default value is just \'\/\' so you don't need to set this.

<br><br>

## 7. Displaying Recipe Items & Using Network Images
Both are normal widgets, a Screen widget also is just a class that extends stateless or stateful widget.
but the way we use these widgets is totally different. so it would make sense to create more sub-folders to make it clear which widgets and which files contain which kind of widget.

we could add **widgets** sub-folder for these normal widgets which we include into other widgets(CategoryItem, MealItem) and **screens** is screen-like widgets (CategoriesScreen, CategoryMealsScreen)

<image src="./images/structure.png" width="400">


### 1) ClipRRect
A widget that clips its child using a rounded rectangle.

```
ClipRRect(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(15),
    topRight: Radius.circular(15)
  ),
  child: Image.network(imageUrl, height: 250, width: double.infinity, fit: BoxFit.cover),
)
```

<image src="./images/clipRRect.png" width="300">

### 2) ClipRect
for more efficient clips without rounded corners.

### 3) ClipOval
for an elliptical clip.

<br><br>

## 8. Finishing the Meal List Item
Please note on every inage that we have rounded corners at the top but not at the bottom


