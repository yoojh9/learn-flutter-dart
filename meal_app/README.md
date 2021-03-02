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

## 5. Passing Data via the Constuctor
