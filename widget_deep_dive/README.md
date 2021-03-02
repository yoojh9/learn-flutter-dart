# Widget & Flutter Deep Divce
## Behind the Scenes & Beyond the Basics

## 1. The problem at Hand
### 1) How flutter actually draws the content?

Flutter executes the build method because build gets executed relatively often and every widget in our application has a build method. So does this means that whenever build runs, Flutter actually redraws the entire screen running build.
That is actually bad becuase as you can imagine, whenever Flutter has to really redraw the pixels on the screen and rebuild all your widgets, your elements that sounds like a performance impact and actually it would be.
The good thing is Flutter doesn't redraw or recreate the entire UI on every build call(실제로는 rebuild 할 때마다 redraw하지는 않음.)

The first important thing to realize is that Flutter aims to give you a 60fps application, so it updates the screen 60 times per second and that of course mean that it does indeed redraw the pixels 60 times per second.

The FPS meaure really just means frames per second and that means that the screen or what you see on the screen is repainted X amount of times per second. so in a 60fps application, that means 60 times per second. 
This would become inefficient if Flutter would have to recalculate the entire layout 60 times per second. becuase when Flutter draws something onto the screen, for the first time, it needs to figure out the position of every element, the color of every element, the text of every element, so it needs to configure every single pixel on the screen. 

For subsequent draws, so for refreshes of the user interface, if nothing changed, Flutter takes the old informaion it already derived and paints that on the screen which is super fast and very efficient. (Flutter에서 첫번째 draw를 끝내면 이후 draw는 변경 사항이 없으면 이미 그려진 정보를 가지고 매우 빠르고 효율적으로 화면에 그린다.)

So the refresh itself is not a problem, It would only be problem if Flutter would have to recalculate everything on thee screen with every refresh.
 
<br><br>

## 2. Widget Tree & Element Tree
**The Widget tree** which you're creating with your code and which is build by Fltter by calling the build method is essentially just a bunch of configuration.
The configuration not directly output on the screen, instead it simply describes to Flutteer what should be ouput on the screen. So It's just a bunch of configuration settings.

**The Element tree** is important because the element tree is created by Flutter automatically based on your widget tree and it links your widgets to the actual rendered objects.

Where the widget tree is constatnly changing basically whenever you call setState(). So whenever the build methods get executed, Flutter rebuilds that widget tree, while that happens relatively often, the element tree is managed differently and does not rebuild with every call to the build method. and it links the widgets, the configuration you set up with the actually rendered elements which are part of the render tree.

**The render tree** is the representation of what really ends up on the screen, what you see on the screen and that also is rarely rebuild.

<image src="./images/widgetTree_and_elementTree.png" width="700">

<br>

### 1) What does this mean for the build method?
The build method is called by Flutter whenever your state changes. There are basically two important treggers that can lead to a rebuild.

**One is when you call setState()**
Widget is a Dart class and that means we instantiate it like any other Dart class. we're doing the exact same thing down there in the build() for container and column and so on. Now since the build method runs again, of course new instances of all these classes are created. So a new widget tree is basically created with new instances of all these widget classes.

**Two is if you use something like mediaQuery.of(context) or Theme.of(context)**
Quering the current media using[MediaQuery.of] will cause your widget to rebuild automatically whenever the [MediaQueryData] changes (e.g. if the user rotates their devices)

for example when you rotate the device, the MediaQueryData changes becuase orientation is information stored in the MediaQueryData therefore rotating your device automatically also triggers build to run. The same is if the soft keyboard appears.

<image src="./images/mediaQuery.png" width="500">

<br><br>

## 3. How Flutter Rebuilds & Repaints the Screen

<image src="./images/widget-element-tree.png" width="700">

In our stateful widget, we call setState(), so something changes there.

This element tree which is not rebuild whenever build() is called, only the widget tree is rebuild and the element tree can automatically updates its references to know if a new configuration is available, it passes that information to the render object so that these can re-render on the screen.

calling build() does not mean that the entire screen re-renders becuase Flutter has a couple of layers to manage that and calling build or the build() being called only menas that this widget tree, so that tree of configuration data rebuild or parts of tree rebuild.
and therefore Flutter checks which parts on the real screen need to be updated.

**Widget Tree**: Provide configuration for element and render tree.
**Element Tree**: Connect widget and render tree, manage state, updatee render tree when widget tree changes.

<br><br>

## 4. Using "const" widgets & Constuctors
Even though rebuilds of the widget aren't that bad, of course it's never a bad idea to avoid unnecessary widget rebuilds becuase that simply means that even though it's just a configuration tree that changes, even if we can avoid a change there, we save some processing time and therefore, can overall improve our application preformance.
One relatively easy improvement is the usage of "const" constuctors and "const" widgets.

### 1) const constructor
we can't make this a const constuctor for non-final fields. 
const constuctor means every instance of this object you create is immuatble, you can't change it.
basically all your StatelessWidget are theoretically immutable 

```
class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPercentageOfTotal;

  const ChartBar(this.label, this.spendingAmount, this.spendingPercentageOfTotal);

}
```

<br><br>


## 5. Using Builder Methods
List<Widget>은 ...(spread operator)를 이용하여 List를 분리할 수도 있다.
These Three dot tell Dart that you want to pull all the elements out of that list and merge them as single elements into that surrounding list which we have.
So instead of adding a list to a list, we're adding all the elements of this list as single items next to each other.

```
  List<Widget> _buildLandscapeContent(
    MediaQueryData mediaQueryData, 
    PreferredSizeWidget appBar,
    Widget transactionListWidget) {
    return [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Show Chart', style: Theme.of(context).textTheme.headline6,),
            Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value: _showChart, 
              onChanged: (value){
                setState(() {
                  _showChart = value;
                });
              })
          ]
        ),
        _showChart ? Container(
            height: (mediaQueryData.size.height - appBar.preferredSize.height - mediaQueryData.padding.top) * 0.7,
            child: Chart(_recentTransaction)
          )
          :
          transactionListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
    MediaQueryData mediaQueryData, 
    PreferredSizeWidget appBar,
    Widget transactionListWidget) {
    return [
        Container(
          height: (mediaQueryData.size.height - appBar.preferredSize.height - mediaQueryData.padding.top) * 0.3,
          child: Chart(_recentTransaction)
        ), transactionListWidget 
    ];
  }

  @override
  Widget build(BuildContext context) {
    
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if(isLandScape) ... _buildLandscapeContent(mediaQuery, _appBar, _transactionListWidget),
              if(!isLandScape) ... _buildPortraitContent(mediaQuery, _appBar, _transactionListWidget),
              //if(!isLandScape) _transactionListWidget,
            ],
            ...
        )
  }
```

<br><br>


## 6. Widget Lifecycle
For Stateful Widget we also have the constructor function, we also have create state beeing called to create that state object.
Inside of state object, you can add an initState() method which will be called automatically, that is executed automatically by Flutter when the state object is created for the first time.
and Remember that the state object is managed independently of the widget, so when the widget is rebuild, initState() will not run again. it only runs when the state is created for the first time.

Thereafter, we have the build() method which executes. Now you can always call setState() to update the widget.
Then didUpdateWidget() executes. and thereafter again, build() run.

if a widget is destroyed, if it's removed because you rendered its condition is false, then dispose() is called. 
So all these special methods, initState, didUpdateWidget, dispose are all methods you can add to your state object and they run when the state is created, when the attached widget changed or when the state object is cleared, is removed.


 <image scr="./images/widget_lifecycle.png" width="700">

 ### 1) initState()
 official docs tell that state that you should call super.initState() first, and therfore put your code after super.initState() not before it. However it actually won't make a difference. 

 ### 2) didUpdateWidget()
 This gets called when the widget is attached to the state changes and then Flutter actually gives you the old widget
 so that you could compare it to the new widget becuase you have that special widget property('widget') which you can use in your state. The 'widget' will now automatically refer to the updated widget, 
 ```
 [new_transaction.dart]
   @override
  void didUpdateWidget(covariant NewTransaction oldWidget) {
    // TODO: implement didUpdateWidget
    // widget 과 oldWidget 비교할 수 있음.
    super.didUpdateWidget(oldWidget);
  }
 ```

 NewTransaction 위젯에 lifecycle 마다 로그를 찍어보았다.
 + 버튼을 눌러 ModalBottomSheet가 뜨게 해보자.

 <image src="./images/widget_lifecycle_log.png" width="400">

 ```
  flutter: Constuctor NewTransaction Widget
  flutter: CreateState NewTransaction Widget
  flutter: Constuctor NewTransaction State
  flutter: initState()

  flutter: Constuctor NewTransaction Widget
  flutter: didUpdateWidget()

 ```

what we see now also is that createState is not called again and therefore, the constructor of the State and initState() is not called again. becuase The state is managed as a seperate object and when the widget rebuilds, the state is not recreated automatically.

didUpdateWidget() is executed because the widget attached to the state was replaced.

Now when I close this by clicking somewhere on the backdrop, you can see that it recreates this widget, and then didUpdateWidget() in the end, you see dispose() is called once.

The render object is removed because that needs to be removed, you don't want to see it on the screen anymore.
and dispose is called because when the element is cleared, the state object is cleared as well and therefore removed.


```
flutter: Constuctor NewTransaction Widget
flutter: didUpdateWidget()

flutter: dispose()

```
<br>

**initState()** is often used for fetching some initial data you need in your app or in a widget of your app.
<br>

**didUpdateWidget()** is probably used way less often, you could use it if you know something changed in your parent widget and you need to refetch data in your state. so if you're fetching data from a database, you want to fetch new Data, you could do this here in didUpdatWidget() with the information.

<br> 
**dispose()** is greate for cleaning up data

Let's say you have a listener to a real time Internet connection which sends you new messages because you're buidling a chat application or anything like that, then you want to clean up this connection to your server here when your widget is removed, so that you don't have that ongoing connection in memory even though you have no widget anymore, this will lead to strange bugs and also to memory leaks. So cleaning up listeners or life connection, that is something you would often do in dispose

<br><br>


## 7. Understanding the App Lifecycle
There's a couple of diffrent licycle status, and the important question is when is this state reached, when can you execute code based on the state.

for example you have the **inactive** state. Inactive means that your app is not even running in background, it's inactive, the user can't see it, it cant' receive user input. It's not fully cleared from memory yet but it's definitely not too active.

A state can be reached on operating system is **paused**. this is when the app is not visible and when it's running in background, so when you can reach it through the task manager of your application. This is available on both Android and iOS and you can react to the app transitioning into that mode in your code, for example to do some last minute cleanup, clear some connection to a server or anything like that.  

of course, since you have paused, you also have **resumed**. This state is reached when your app is coming back from the background mode if it's again visible and again responding to user input and this is also available both on Android and iOS.
So this would be a good place to again set up a live connection to a server, check whether you want to change something in your app, fetch new data, anything like that 

and there also is a **suspending** state which is when the app is about to be suspended, so when it's almost gone but still there but when it's about to be cleared by the operating system, when it's about to be removed from memory.

<image src="./images/app_lifecycle.png" width="500">

<br>

### 1) mixin
it's a bit like a class and it's a bit like extenidng a class but it adds a certain feature from that class you're mixing into your class, so you're adding certain properties, certain methods this other class has without fully inheriting other class. 
you only can inherit from one class, so if you want to bring in features from multiple classes, you would use a mixin.
You use a mixin by adding a **'with'** keyword after your class and after all your extensions

<br>

The new method you can add is **didChangeAppLifecycleState()**, that is a method added by the mixin and therefore we add @Override to make clear the we deliberately override this. 
So this method will be called whenever your licecyles state changes, whenever the app reaches a new state in lifecycle.

You also want to clear that listener to lifecycle changes when that state object is not required anymore. So let's add dispose here with @Override and call super.dispose() and clear listeners to lifecycle changes. it you have ap bigger app and you add your app lifecycle listeners in just one child widget somewhere down the widget tree of your app because in that child widget you're interested in changes to the lifecycle of the app, 
well then when the child widget gets removed, you certainly also want to clear your lifecycle listeners to avoid memory leaks.

So in dispose, you clear all listeners you have to the app lifecycle. call **WidgetsBinding.instance.removeObserver()** in dispose()

Now before you can remove it, you also need to set up a listener, so for this method to be triggered, you need to add a listener and you do this by adding initState() and there you now use widgets binding instance add Observer.

**WidgetsBinding.instance.addObserver(this);** So with this line, you're saying or you're telling Flutter hey, whenever my lifecycle state changes, I want you to go to a certain observer and call the didChangeAppLifecycleState() method. 

```
[main.dart]

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

}
```

#### (1) 앱 실행 후 홈버튼 눌렀을 때.
this is just paused, it's running in background.

```
[console]
flutter: AppLifecycleState.inactive
flutter: AppLifecycleState.paused
```

#### (2) task manager 열고 다시 app으로 돌아오면,
basically during this switch, it goes into inactive but then it enters resume becuase not it's getting back from paused to running again

``` 
[console]
flutter: AppLifecycleState.inactive
flutter: AppLifecycleState.resumed
```

#### (3) app을 task manager에서 완전히 날렸을 경우, 

``` 
[console]
flutter: AppLifecycleState.inactive
flutter: AppLifecycleState.paused
Lost connection to device.
```

<br><br>


## 8. Understanding Context
in build() method, you always get this build context argument, now what's this build context about? 
we also use it for example in conjunction with mediaQuery or with theming with this of context method.
What's the idea behind context? In Flutter, every widget has its own context.
so every widget has its own context attached to it and that's the context to get in the build method.

That's why if you have certain builder methods, like for showModalBottomSheet(), the function you pass there, like this, actually receives a context. this function receives a context automatically passed in by Flutter becuase builder functions like this also return a new Widget in the end and that widget has its own context.

```
  void _startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(context: ctx, builder: (context){
      return NewTransaction(_addNewTransaction);
    });
  }
```

So context is everywhere and every widget has its own context attached. in the end the context is the element of a widget in the element tree you could say. it's some meta information about the widget and its location in the widget tree.
Context is used internally by Flutter to understand where this widget belongs and all the contexts of all the widgets.
Therefore these context you could say know about each other, they know how widgets are related, how they belong together. The contexts build a skeleton of your widget tree, that's how you could think about that.

So that context gives you a direct communication channels across your entire widget tree because all contexts in the end know about each other, they know where in the widget tree they are and which other widgets exsist around them.

That's why for example for accessing the theme or for navigation or for mediaQuery you use the context because Flutter has a very efficient communication channel behind the scenes for passing data between widgets. we always pass data between widgets by using their constructor. This is the default way of passing data

<image src="./images/understanding_context.png" width="600">

<br>

but If you have a large widget tree, then passing data between these widgets can get cumbersome, we'll learn about a feature called InheritedWidget that helps us with making that simpler.

we have a relatively large widget tree with our app widget. SingleProduct and ProductDetail widget is sibling widget of Products widget. 
if we need some information that's managed in the state of my app in our product detail widget, we have to pass that data down through all the widgets all the way down to the product detail widget. that's why we're currently doing in the app.

<image src="./images/inherited_widget1.png" width="600">

Flutter gives us a special widget, the InheritedWidget. we never used that but mediaQuery and theme uses that behind the scenes and you get a direct tunnel to the InheritedWidget and to data manged in there with the help of context becuase the context know about the general structure of your widget tree and therefore, they can directly access any other widget without passing data through arguments.

<image src="./images/inherited_widget2.png" width="600">

예를 들어 themeData 같은 경우 생성자를 통해 데이터를 전달하지 않고도, 위젯에서 Theme.of(context).textTheme.headline6와 같이 접근할 수 있음. 

```
[main.dart]
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Personal Expenses',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          accentColor: Colors.amber,
          errorColor: Colors.red,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'Open Sans',
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
            button: TextStyle(color: Colors.white),
          ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'Open Sans', 
                fontSize: 20,
                fontWeight: FontWeight.bold
              ), 
            ),
          ),
        ),
        home: MyHomePage(),
      );
  }
}
```

we'll actually also take advantage of this idea of passing data behind the scene. 

<br><br>


## 9. A problem with List & Stateful Widget
in transaction_item.dart file we have this strange 'key' thing and this strange syntax after our constuctor.
Every widget can have a key. 
all the widget we created manually don't accept a key argument in their constuctor, and reason for this is that most of your widget don't need a key, especially stateless widgets, so you don't have to accept this argument.

let's our transaction_item would not be a StatelessWidget but a StatefulWidget. so I'll convert it to a StatefulWidget.
and I'll use initState() to set some dynamic data for this widget which is created.


```
[transaction_item.dart]

  @override
  void initState() {
    const availableColors  = [Colors.red, Colors.black, Colors.blue, Colors.purple];
    _bgColor = availableColors[Random().nextInt(4).toInt()];
    super.initState();
  }
```

<image src="./images/capture1.png" width="400">

test5 아이템을 지우면 test6 아이템이 파란색으로 변경되는 것을 볼 수 있다. 이는 widget이 지워져도 state는 남아있어 발생하는 문제이다.

<image src="./images/capture2.png" width="400">

<br><br>

## 10. Using keys
keys are really useful in situations like this. on that Card widget, we could set a key if that would be our root level widget in our ListView. Flutter has a couple of built-in keys and attached. UniqueKey() class is built into Flutter and it 
automatically creates a unique key for every item, so every new item gets its own unique key attached. 
but UniqueKey is not really great. if this rebuilds constantly  

```
[transaction_list.dart]
  @override
  Widget build(BuildContext context) {
    ...

      ListView(
        children:
          transactions.map((transaction) => TransactionItem(
            key: UniqueKey(), 
            transaction: transaction, 
            deleteTransaction: deleteTransaction,)
          ).toList()
      );
      ...
  }

[transaction_item.dart]
class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTransaction,
  }) : super(key: key);
}
```

TransactionItem 생성자에 key로 UniqueKey()를 전달할 경우, setState()가 호출될 때마다 rebuild 되어 background 색깔이 계속 랜덤으로 바뀌는 문제가 생긴다.

<image src="./images/capture3.png" width="400">

<image src="./images/capture4.png" width="400">

<br>

even if nothing inside of the list(transaction_item.dart) changes but the parent widget(transaction_list.dart) changed, 
you get a new unique key assigned and therefore, Flutter is not able to match up the items and it loses your data. 
so instead, you should use a **ValueKey**, that is a key where you pass your own indenfier and that of course should be a value that is unique to every list item you have.

(with new keys generated constantly, Flutter finds no widgets for the elements that now look for widget type + key. Hence new state object are created all the time) the Transaction.Id is perfect for key.
Unlike UniqueKey(), ValueKey() does not calculate a random value but simply wraps a non-changing identifier provided by you.

```

[transaction_list.dart]
  @override
  Widget build(BuildContext context) {
    ...

      ListView(
        children:
          transactions.map((transaction) => TransactionItem(
            key: ValueKey(transaction.id), 
            transaction: transaction, 
            deleteTransaction: deleteTransaction,)
          ).toList()
      );
      ...
  }

```

 now if the first widget gets removed and of course keep in mind that our state is also attached to our elements.
 If the first widget gets removed, now Flutter when it checks the element tree finds out that this element has no matching widget anymore because it does find another widget which is of type item but not with a key of 1, this has a key of 2.
 Therefore Flutter goes ahead and destorys this element and does not try to reattach the state to this widget.

 Keys simply make it easier for Flutter to identify the connected widget.
 keys help Flutter link elements(element tree) and widgets(widget tree) correctly.
 You sould really only use keys when you need them though, don't start using them everywhere on every widget becuase Flutter by default doesn't need them.