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
Please note on every inage that we have rounded corners at the top but not at the bottom. at the bottom we have normal corners. 

### 1) positioned
when you're in a stack, you can use a special widget which really only works inside of a stack.
You can wrap text with widget **positioned**. Positioned allows us to position the child widget in an absoulte coordinate space. we can add of properties(bottom, left, right, top). so we can tell how far away we want to be from the bottom, from the left, from the right and from the top in our stack and the stack container itself is defined by its biggest child which clearly is our image.

we want to have 20 pixels distance from the bottom and 0 pixels or 10 pixels distance from the right to position it in the bottom right corner.

```
Positioned(
  bottom: 20,
  right: 10,
  child: Text(
    title, 
    style: TextStyle(fontSize: 26, color: Colors.white), 
    softWrap: true,
    overflow: TextOverflow.fade,
  ),
)
```

이렇게 설정할 경우 아래 이미지처럼 텍스트가 길어질 경우 잘리게 됨

<image src="./images/overflow.png" width="300">

Text 위젯을 Container 위젯으로 wrapping 하고 width를 지정한다.

```
Positioned(
  bottom: 20,
  right: 10,
  child: Container(
    width: 250,
    color: Colors.black54,
    padding: EdgeInsets.symmetric(vertical:5, horizontal: 20),
    child: Text(
      title, 
      style: TextStyle(fontSize: 26, color: Colors.white), 
      softWrap: true,
      overflow: TextOverflow.fade,
    ),
  ),
)
```

<br><br>

## 9. Scaffold
evey widget which you use as a standalone page, which occupies the entire content of the page, so which you don't include just into other widgets, every standalone widget which you load through routing, which you navigate to with the navigator needs a scaffold widget bacause that adds the background, the appBar and also in general, connects the widget to our material app and to the theme set up there to the fonts.

<br><br>

## 10. onGenerateRoute & onUnknownRoute
when you use pushNamed() you need to register to page, the route for that page in the main.dart file, when you use push(), you create the route with the MaterialPageRoute class. for pushNamed() you have to set up this routes table in the main.dart file. 굳이 설정 안해도 됨. 

### 1) onGenerateRoute
this takes a function which gives you some route settings, so some information about the route, like the argument. and That should also return a route. So you should return a MaterialPageRoute.
If you are going to a named route, with pushNamed, that is not registered in the routes table and then reach the onGanerateRoute screen.
any route that's not registered in the routes screen, as long as we try to reacth it through a named route. 

### 2) onUnknownRoute
onUnknownRoute is reached when Flutter failed to build a screen with all other mesures.
if you don't use onGenerateRoute, then in the end as a last result before it throws an error, Flutter will try to use onUnknownRoute to shouw something on the screen. (404 error page)

<br><br>

## 11. Adding a TabBar
I want tabs at the bottom of this categoryScreen and also at the bottom of this to be added favoriteScreen.
we will add a totally new screen and I'll name that tabs_screen.dart.
TabScreen will only manage the tabs and then load different screens depending on which tab was selected. 
So the TabScreen itself is a widget, though it will be a stateful widget.

TabScreen has the goal of rendering the tabs and then the appropriate content for each tab depending on which tab was selected. TabScreen will fill out the overall page in the build() method, Hence we should return a scaffold widget because you learned if you want to manage the entire screen with a widget, you typically use a scaffold since this sets the background color, lets you add an appBar and lets you add tabs.

<br>

### actually, these are two ways of adding tabs to Flutter apps.

#### (1) Adding a TabBar to the AppBar
The first way is that you add the tabs not at the bottom of the screen but at the bottom of your appBar
For that pattern, you actually don't return a scaffold here but a DefaultTabController widget which then has a Scaffold widget as its child.

```
[tabs_screen.dart]

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Meals'),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.category),
                text: 'Category'
              ),
              Tab(
                icon: Icon(Icons.star),
                text: 'Favorite'
              )
            ],
          )
        ),
        body: TabBarView(
          children: [
            CategoriesScreen(),
            FavoriteScreen()
          ],
        ),
      ),
    );
  }
}
```

Remember that for FavoriteScreen, as you see, we not add a scaffold here, The reason for that is that the FavoriteScreen still is like a screen, it still occupies the majority of our page but it doesn't manage the entire page. 
Of course, we still have our tabs in the appBar of the TabScreen up there, So the content we load into a tab should  not bring its own scaffold because it will not control the entire page. instead it will be a part of the TabScreen, the FavoriteScreen is now only controlling that bottom part

```
[favorite_screen.dart]
class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Favorite'),);
  }
}
```

<image src="./images/tab_view.png" width="300">

So for the CategoryScreen, you should now alsh get rid of the scaffold and just return what you want to show in the content,

```
[category_screen.dart]
class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView(
        padding: const EdgeInsets.all(25),
        children: DUMMY_CATEGORIES.map((category) => CategoryItem(category.id, category.title, category.color)).toList(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20
          )
    );
  }
}
```


#### (2) Adding a Bottom TabBar