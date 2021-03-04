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

So for the CategoryScreen, you should now get rid of the scaffold and just return what you want to show in the content,

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

<br>

#### (2) Adding a Bottom TabBar
for this approach of adding tabs, we wouldn't have needed a stateful widget though, a stateless widget would have done the trick because we're not managing any state. 
That will change when we add tabs at the bottom becuase that simply works a bit different. the Flutter Team wants it to work like this. 
There you won't use the DefaultTabController, instead we'll remove the defauDefaultTabController and therefore return the Scaffold in the TabScreen,
and now on that scaffold if you want to have tabs at the bottom, you don't add them on the appBar, 

so you get rid of that bottom argument on the appBar where you added the TabBar, that's removed. and you also don't have a TabBar view as your body.
instead you will add a bottomNavigationBar.

and that is the biggest difference compared to the tabs we added at the top below our appBar, For the bototmNavigationBar you manually have to control what the user selected and which content you want to display. So for that on the bottomNavigationBar itself, you register an onTap listener and that is triggered whenever an item is selected.

```
[tabs_screen.dart]

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final List<Widget> _pages = [
    CategoriesScreen(),
    FavoriteScreen(),
  ];

  int _selectedPageIndex = 0;
  
  void _selectPage(int index){
    setState(() {
      _selectedPageIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals'),
      ),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          _selectPage(index);
        }, // automatically receive index.
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites')
        ],
        elevation: 5,
      )
    );
  }
}

```

<image src="./images/bottom_tabbar.png" width="300">

<br><br>


## 12. Adding a Custom Drawer
You can add a drawer by simply to your scaffold, not to the appBar but to the scaffold. and there you can add a drawer argument.
The drawer argument typically takes a drawer widget which is a widget built into Flutter, which automatically gives you a drawer.
on that drawer, you can add any content you want, any widgets you want.

```
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
      ),
      drawer: Drawer(child: Text('The Drawer!'),),
      body:...
    )
```

this line of drawer code gives us this hamburger icon, automatically managed by Flutter. if tap it, this drawer slides open.

<image src="./images/drawer_1.png" width="300">

You would not just add a boring text here but a more meaningful content. Now the content I do want to add here are essentially two buttons, two links.

I want to add a background color to the overall container where I use my accent color. we can do this with the 'color' argument on the Container.
By the way, an alternative always is decoration with BoxDecoration where you then set the color, this does the same as the color argument. 

However If you do use decoration, you have to set the color through the decoration and not through the color key, otherwise you would get an error by Flutter.

```
class MainDrawer extends StatelessWidget {
  Widget _buildListTile(String title, IconData icon){
    return ListTile(
      leading: Icon(icon, size: 26),
      title: Text(title, style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 24, fontWeight: FontWeight.bold),),
      onTap: () {
        // ... ToDo
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120, 
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).accentColor,
            child: Text('Cooking Up!', style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 30,
              color: Theme.of(context).primaryColor),
            ), 
          ),
          SizedBox(height: 20,),
          _buildListTile('Meals', Icons.restaurant),
          _buildListTile('Filters', Icons.settings),
        ],
      ),
    );
  }
}
```

<image src="./images/drawer_2.png" width="300">

<br><br>


## 13. Replacing Pages (Instead of Pushing)
Drawer 메뉴 중 FilterScreen으로 이동하고 FilterScreen에서 back button을 통해 뒤로 가면,
<image src="./images/replacing_pages1" width="300">

아래와 같은 화면을 볼 수 있다.

<image src="./images/replacing_pages2" width="300">

The solution is relatively simple, all we have to do is in the FilterScreen, we have to add the drawer again and reference our main drawer.

```
class FiltersScreen extends StatelessWidget {
  static const routeName = '/filters';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Filters')),
      drawer: MainDrawer(),
      body: Text('Filters'),
    );
  }
}
```

### 1) pushReplacementNamed() / pushReplacement()
But there's one behavior which I'm not liking, I'm always pushing my page which I'm loading on top of that stack of pages. 
위에 방식처럼 계속 Drawer로 접근하다 보면, the problem is that we get a stack of pages that's bigger and bigger over time because we never clear the existing pages.

I want to clear my stack and simply push the new page as the only stack page onto my stack.
so if I go to meals, the filters page should be deleted, if I go to filters, the meals page, the tabs page should be deleted automatically.
Now It's easy to do that in FLutter, inside of the drawer, instead of using pushNamed()

You can use pushReplacementNamed() or if you have no named route but you create it in place, you also have pushReplacement and then you would pass a MaterialPageRoute.

You will replace the existing page on the stack with the new page. so you don't add the new page on top of it in that stack of pages but you replace the existing page and hence you would also not get a back button. 

Now we avoid that our stack gets bigger and bigger. 

If I do full restart the app and I then go to filter screen, you see now we have no back button. and the reason for that is that Flutter recognizes that noting is on the stack, that are no page to go back to because we didn't keep the old page and push the new one on top of it,
instead we replaced the old page, we deleted it and then added the new page and hence we can't go back.

To replace the existing page, for example also when you add user authentication, when you entered your login data and you hit login and you then reach your main app, typically you don't want to provide a back button to go back to the login becuase you already are logged in.

with the drawer, it's just another example to avoid an infinitely growing stack of pages behind the scenes which could lead to memory problems at some point of time.

<br><br>


## 14. Popping pages & Passing Data Back
sometimes you need to pass some data back to the previous page.
Pop removes screens that are on top of the stack.
Pop can be very useful if you have somthing in your code that requires you to go back or to remove a dialog or some other overlay from the screen in code.
You also have popAndPushNamed(), it pops the current page off and thereafter, it pushes a new named page.
canPop() check where you actually can go back before you do call pop might be a good idea if you're not sure whether you have another page in your app.

we can also pass some data to pop. you can pass any data you want, a map, a list, a String, a number, an object whatever you want.

```
[meal_detail_screen.dart]
floatingActionButton: FloatingActionButton(
  child: Icon(Icons.delete), 
  onPressed: (){
    Navigator.of(context).pop(mealId);
  },
),

[meal_item.dart]
void selectMeal(BuildContext context) {
  Navigator.of(context)
    .pushNamed(MealDetailScreen.routeName, arguments: id)
    .then((result) => print(result));
}
```

<br>

pop()에서 전달한 mealId를 기준으로 categoryMealScreen에서 해당 meal을 삭제하려고 한다.
- StatelessWidget -> StatefulWidget으로 변경한다.
- state가 변경되면 build()가 계속 호출되므로, 기존 build() 메소드에 있던 데이터 세팅 작업은 initState()로 옮긴다.

```
// 아래 작업은 initState()에서 진행되도록 한다.
  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
    final categoryTitle = routeArgs['title'];
    final categoryId = routeArgs['id'];
    final categoryMeals = DUMMY_MEALS.where((meal) => meal.categoryIds.contains(categoryId)).toList();
  }

  @override
  void initState() {
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
    categoryTitle = routeArgs['title'];
    final categoryId = routeArgs['id'];
    displayedMeals = DUMMY_MEALS.where((meal) => meal.categoryIds.contains(categoryId)).toList();
   
    super.initState();
  }

```

Now we'll load data when this component or when this widget is created and we can therfore also manipulate our data and update the user interface becuase we're in s StatefulWidget

initState()를 변경하고 실행시키면 에러가 발생하는데,
The problem is that this call which modalRoute.of(context).
this does not work becuase context generally is thankfully a property that's globally available in our state object but not inside of initState because initState runs too early, it runs before our widget has been created or fully created and before we have a context for our widget.
So what's the solution for that? There is another lifecycle hook which I haven't mentioned before and that's **didChangeDependencies()**

<br>

### 1) didChangeDependencies()
it's really useful because this will be triggered essentially whenever the references of the state change, which also means it will be called when the widget that belongs to the state has been fully initialized. and we can tap into context. this will still run before build runs.

so I can put my code which I had in initState(), initState() would have been great if we wouldn't have required to use modalRoute.of(context).
so any .of(context) stuff which you need to do will unfortunately not work but in didChangeDependencies.

if I delete this, still there. Reason for that is that didChangeDependencies() runs couple of times after the initialization of that state, 
that's the difference to initState. It runs whenever the dependencies of this stat change and that's also the case when the attached widget changes,
which unfortunately is the case when we call setState().  

So the state we set where we do delete a meal is basically overwritten when didChangeDependencies() runs again and we basically load all meeals again.


```
[category_meals_screen.dart]

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  String categoryTitle;
  List<Meal> displayedMeals;
  bool _loadedInitData = false;

  @override
  void initState() {
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    if(_loadedInitData == false){
      final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
      categoryTitle = routeArgs['title'];
      final categoryId = routeArgs['id'];
      displayedMeals = DUMMY_MEALS.where((meal) => meal.categoryIds.contains(categoryId)).toList();
      _loadedInitData = true;
    } 
    super.didChangeDependencies();
  }
  
  void _removeMeal(String mealId) {
    print('_removeMeal($mealId)');
    setState(() {
      displayedMeals.removeWhere((meal) => meal.id == mealId);
    });
  }
```