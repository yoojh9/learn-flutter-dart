# Responseve & Adaptive UI
## Different Device Sizes & Operating Systems 

<br>

## 1. What does "Responsive" and "Adaptive" Mean?

### 1) What does "Responsive" Mean?
Responsiveness in Ui desin and Ui development is all about handling different sizes.
for example for your app, you of course might most commonly have portrait mode users or devices so that users use your app on a phone which is in portrait mode. 
but some user can also rotate that device and view your app in landscape mode and maybe you want to adjust your app there a little bit to look better in landscape mode and be better usable there.
in addition, people might not just use your app on phones but also on bigger phone or on tablets. 
wherever Android or iOS or whichever platform you're building for runs, you might want to support that and don't show the same layout and all different device sizes.

<image src="./images/responsive.png" width="700">

<br>

### 2) What does "Adaptive" Mean?
is related to adapting your user interface to different operating systems, you look on Android and you want to have a certain probably different look and feel on iOS. 

<image src="./images/adaptive.png" width="700">

<br>

### 3) Responsive & Adaptive Apps in Flutter
our overall goal in Flutter is that we still only use one codebase, one project. we don't want to start building totally different apps just for the different platforms.
So we absolutely want to stick in that one codebase and therefore, we also will have one widget tree.
The only way for us to make our apps responsive and adaptive is that we detect which platform we're running on or which device size we have available in our code,
in our widget tree and then, we render certain sub-trees, certain individual widgets based on the platform or on the device size we have
therfore we have one widget tree but in certain points of that tree, we have an either/or decision where we render differently styled widgets or totally different widgets based on the size or on the platform

<image src="./images/responsive&adaptive.png" width="700">

<br><br>

## 2. Calculating Sized Dynamically
what the general device height is? there is a specific class we can use, the mediaQuery class. 

```
MediaQuery.of(context)
```

context is this metadata object with some information about our widget and its position in the tree. 
MediaQuery.of(context) this connection also allows us to find out which general device size we have available.

<br>

```
height: MediaQuery.of(context).size.height
```

this would be the full device height we have available. our container list should only take a fraction of that height which is why we can simply multiply this height with a value between 0 and 1.


but I want to deduct the appBar height from that. 

use '(MediaQuery.of(context).size.height - appBar.preferredSize.height) * 0.4,'
you have to deduct the height of the appBar on both calculation becuase we then use a fraction of that and we want to use a fration of the available space 
and available space is always (full height - appBar height)

**preferredSize** is a property we can access on the appBar to get the height that is reserved there or the dimensions that are reserved.

또한 statusBar 높이도 빼줘야 한다. 

Flutter gives us the padding automatically, add around a wrap for typical UI interfaces or typical UI elements, like the system status bar.
this example we want to get the padding from the top which is for the status bar

```
  @override
  Widget build(BuildContext context) {
    final appBar =  AppBar(
        title: Text('Personal Expenses', style: TextStyle(fontFamily: 'Open Sans'),),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: () => _startAddNewTransaction(context))
        ],
      );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: (MediaQuery.of(context).size.height - appBar.preferredSize.height) * 0.4,
                child: Chart(_recentTransaction)
              ),
              Container(
                height: (MediaQuery.of(context).size.height - appBar.preferredSize.height) * 0.6,
                child: TransactionList(_transactions, _deleteTransaction)
              )
            ],
          ),
      ),
    ....
    );
  }
}
```


<br><br>

## 3. textScaleFactor
In this course, I mostly focus on the device sizes (height and width) when it comes to working with the MediaQuery class.
As mentioned, it offers way more than that of course. On particularly interesting property is the textScaleFactor property:

```
final curScaleFactor = MediaQuery.of(context).textScaleFactor;
```

**textScaleFactor** tells you by how much text output in the app should be scaled. Users can change this in their mobile phone / device settings.

Depending on your app, you might want to consider using this piece of information when setting font sizes.

Consider this example:

```
Text('Always the same size!', style: TextStyle(fontSize: 20));
```

This text ALWAYS has a size of 20 device pixels, no matter what the user changed in his / her device settings.

```
Text('This changes!', style: TextStyle(fontSize: 20 * curScaleFactor));
```

This text on the other hand also has a size of 20 if the user didn't change anything in the settings (because textScaleFactor by default is 1). But if changes were made, the font size of this text respects the user settings.

<br><br>

## 4. Using the LayoutBuilder widget

<image src="./images/current_app.png" width="300">

Now the remaining thing is that we maybe want to adjust our chart and we can adjust it in two different ways.
we can either make sure that our bars here take the full available height or that we shrink the height a little bit.
our current app that's too much height in chart widget. but I also want to make sure that if we have it on a slightly bigger device, we never have an empty white space at the bottom.


```
// 현재 CharBar widget
 Container(
          height: 60, 
          width: 10,
          child: Stack(
            children: []
          )
          ....
```

we want size that dynamically. To size this chart bar dynamically, we need to find out which available height we have.

<br>

<image src="./images/chart_row.png" width="300">

### 1) LayoutBuilder

LayoutBuilder는 부모 Widget의 사이즈에 종속된 Widget Tree를 build한다.


```
LayoutBuilder(builder: (ctx, constraints)
```

**constraint** is a feature which Flutter offers which defines how much space a certain widget may take. Indeed constraints ared an important concept in Flutter. Constraints define how a widget is rendered on screen and you set constraints. by for example, assigning a height or a widget or otherwise
if you don't set this, all built-in Flutter widgets have their own default constraint.
like for example a ListView has an infinite height, a column also has that but is not scrollable. 
Constraint always refer to height and width and are expressed as a minumum and a maximum height and width you might have on a given widget and you can set them on your own as I juse said or there are some sensible defaults in Flutter.




<image src="./images/constraint.png" width="700">

<br>

we can use constraints object to dynamically calculate the height and width of elements inside of that widget based on the constraints of the sizing, that is applied to our custom widget from outside.

So the best solution here might be to assign dynamically calculated heights to all these elements. 

```
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints){
      return Column(
      children: [
        Container(
          height: constraints.maxHeight * 0.15,
          child: FittedBox(
            child: Text('\$${spendingAmount.toStringAsFixed(0)}')
            )
        ),
        SizedBox(height: constraints.maxHeight * 0.05,),
        Container(
          height: constraints.maxHeight * 0.6, 
          width: 10,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey, width: 1.0),
                  color: Color.fromRGBO(220, 220, 220, 1),  // RGBA
                ),  
              ),
              FractionallySizedBox(
                heightFactor: spendingPercentageOfTotal, 
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10)
                  ),
                )
              )
          ]
        ),
      ),
      SizedBox(height: constraints.maxHeight * 0.05,),
      Container(
        height : constraints.maxHeight * 0.15, 
        child: FittedBox(child: Text(label))
      ),
      ],
    );
    }); 
  }
```


## 5. Controlling the Device Orientation
- simply don't allow landscape mode

```
[main.dart]

void main() { 
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown, 
      DeviceOrientation.portraitUp
  ]);
  runApp(MyApp());
}
```

- Landscape 전용 widget을 만든다. 예를 들어 Chart는 Landscape 모드에서 toggle 버튼을 만들어 토글 버튼을 누를 때만 보여준다.

<br><br>

## 6. Finishing Landscape Mode
landscape 모드에서는 여전히 이미지 크기로 인해 에러가 발생함.

<image src="./images/landscape.png" width="400">

이유는, TransactionList에서 이미지 height을 200으로 직접 설정했기 때문.

```
  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? Column(
          children:[
            Text('No transactions added yet!', style: Theme.of(context).textTheme.headline6,),
            SizedBox(height: 10,),
            Container(
              height: 200,
              child: Image.asset('assets/images/waiting.png', fit: BoxFit.cover)
            )
          ]
        )
```

TransactionList 클래스에서도 LayoutBuilder를 사용하여 문제를 해결해보자.

```
  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints){
          return Column(
            children:[
              Text('No transactions added yet!', style: Theme.of(context).textTheme.headline6,),
              SizedBox(height: 10,),
              Container(
                height: constraints.maxHeight * 0.6,
                child: Image.asset('assets/images/waiting.png', fit: BoxFit.cover)
              )
            ]
          );
        }) 
```

<br><br>

## 7. Showing Different Content Based on Device Orientation
MediaQuery를 이용하여 orientation도 구할 수 있다.

```
[main.dart]
  @override
  Widget build(BuildContext context) {
    final isLandScape = MediaQuery.of(context).orientation == Orientation.landscape
```

it's allows to add an 'if' statements here in that list.
list에서는 if 문을 사용할 수 있음. 대신 {}는 사용하지 않음.

```
    if(!isLandScape) Container(
    height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.3,
    child: Chart(_recentTransaction)
    ), 
    if(!isLandScape) _transactionListWidget,
    if(isLandScape) _showChart ? Container(
    height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.3,
    child: Chart(_recentTransaction)
    )
    :
    _transactionListWidget
```

So this is now how we can also render different content based on the orientation 

<br><br>

## 8. Respecting the Softkeyboard Insets
smaller screen or landscape mode we can't really type and we constantly have to close the keyboard to get to the other inputs.
thankfully, Flutter provides us with the tool to work around that issue and find out how much space is occupied by that soft keyboard and actually move that entire box up by that space. so we can still type in there.

<image src="./images/landscape_softkey.png" width="500">

<br>

that tell us how much space is occupied by that keyboard. and I want to adjust the bottom padding by that space +10 which should always there to lift upward, to move up my entire input area.

```
[new_transaction.dart]

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: MediaQuery.of(context).viewInsets.bottom + 10),
```

but, if I now tap in there, you see we have that bottom overflow problem. and that simply happens because that general modal sheet has the height it has. Now to work around that, we can simply wrap this entire card into a SingleChildScrollView, 
<image src="./images/softkey_up.png" width="300">

<br>

so now if i tap in there, now we can scroll everything into view and that's certainly better than the solution we had before

<br><br>

## 9. Using the Device Size in Conditions
if we have more width available, may be we want to show more information that on smaller screens. 
The concrete example I have in mind is that we could show some helper text next to that trash icon.
이 예제에서는 orientation이 landscape 기준일 때 보이는게 아니라 width 기준으로 width가 넓으면 trash icon 옆에 text가 보이도록 만들어본다.

I really only cared about the available width not about the orientation. so even if we are in portrait mode but let's say we have a very large device, then I might still want to show that text. 
we can also use the size and there the width in a condition.

```
  trailing: MediaQuery.of(context).size.width > 400 ? FlatButton.icon(
      textColor: Theme.of(context).errorColor,
      onPressed: () => deleteTransaction(transactions[index].id),
      icon: Icon(Icons.delete), 
      label: Text('delete'))
    : IconButton(
    icon: Icon(Icons.delete),  
    color: Theme.of(context).errorColor, 
    onPressed: () => deleteTransaction(transactions[index].id)
```

<br><br>

## 10. Managing the MediaQuery Object
MediaQuery.of(context)를 중복해서 사용한다면, build()메소드 아래에 final mediaQuery = MediaQuery.of(context); 로 변수를 지정해서 변수를 사용한다.

if you set up one connection, get the media query data once and store that in one object and then you reuse that object throughout your widget tree or throughout your build method which is more efficient.
whenever this is rebuilt becuase the orientation changed for example, then build will run again and threfore, you will create a new variable with a new value. so defining media query variable at build() makes sense.

<br><br>

## 11. Checking the Device Platform
we'll dive into creating adaptive user interfaces where we still work in one and the same codebase but now we do it such that we actually build a different user interface regarding its styling and the look and feel for iOS.

If you have that switch there, you can easily get the iOS look by going to the place where you're using the switch.
for some widget, like the Switch and the official docs tell you when that is available, you can use a speacial constuctor, the adaptive constuctor, It takes the same configuration as the normal switch but the difference here is that it automatically adjusts the look based on the platform. 

widget that looks more iOS-like on iOS and doesn't have the default material look. 

```
Switch.adaptive(
  activeColor: Theme.of(context).accentColor,
  value: _showChart, 
  onChanged: (value){
    setState(() {
      _showChart = value;
    });
  })
```

<br>

<image scr="./images/ios-styled.png" width="400">

Switch.adaptive()를 통해 iOS 스타일의 Switch 버튼으로 변경된 것을 볼 수 있다.

<br>

FloatingButton을 iOS 스타일로 변경하고 싶으면 어떻게 해야할까?
dart:io를 다른 패키지들보다 가장 상단에 import 시킨다. 

```
floatingActionButton: Platform.isIOS 
  ? Container() 
  : FloatingActionButton(child: Icon(Icons.add), onPressed: () => _startAddNewTransaction(context),),
```

the Platform is very useful and it allows you to check for a broad variety of platforms.

<br><br>

## 12. Using Cupertino (iOS) widget
### 1) CupertinoPageScaffold
What about other things like the appBar or the general look of this page? By deault, we have the material design becuase we're using in our main.dart file, in the build method is this scaffold.
the scaffold widget by default gives us a page for material design widgets.
There also is a Cupertino and iOS version. we have the **CupertinoPageScaffold** 

You need to add an import to package:flutter/cupertino.dart just as we used material.dart

```
import 'package:flutter/cupertino.dart';



@override
Widget build(){
  final _appBar =  Platform.isIOS 
     ? CupertinoNavigationBar(
        middle: Text('Personal Expenses', style: TextStyle(fontFamily: 'Open Sans'),),
        trailing: Row(children: [
         GestureDetector(
           child: Icon(CupertinoIcons.add),
           onTap: () => _startAddNewTransaction(context),
         )
       ],),
     )
    
     : AppBar(
        title: Text('Personal Expenses', style: TextStyle(fontFamily: 'Open Sans'),),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: () => _startAddNewTransaction(context))
        ],
    );
  ...

  return Platform.isIOS 
    ? CupertinoPageScaffold(
      navigationBar: _appBar,
      child: _pageBody
      )
    :Scaffold(
      appBar: _appBar,
      body: _pageBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS 
        ? Container() 
        : FloatingActionButton(child: Icon(Icons.add), onPressed: () => _startAddNewTransaction(context),),
    );
}
```
<br>

### 2) CupertinoNavigationBar
CupertinoPageScaffold 'navigationBar' property is instead of appBar in scaffold.
we actually use [CupertinoNavigationBar](https://api.flutter.dev/flutter/cupertino/CupertinoNavigationBar-class.html).


위처럼 추가할 경우 _appBar.preferredSize에서 에러가 발생한다.
that actually is taken from the appBar and I want to calculate the preferred size for both my CupertinoNavigationBar as well as for this appBar. Now small problem is that I'm getting an error that preffered size is not defined on widget.
The reason for that is actually that appBar is inferred to be of type widget. Now that simply happens becuase Dart is not able to find out that CupertinoNavigationBar and appBar both have a preferred size property. but actually, if we add a dot after CupertinoNavigationBar, we see there is a preferred size property.

<br>
위 문제를 해결하기 위해 final appBar에 type을 추가해준다.
that's one of the cases where it make sense to explicitly set the type. 
if you known what the type, but Dart can't find out. and set this to PreferredSizeWidget.
Now you get rid of these type erros down 

```
final PreferredSizeWidget 
```

CupertinoPageScaffold doesn't have title property so instead, you target the **middle** property.

of course, you also want to add some actions in CupertinoNavigationBar. use **trailing** property instead of actions to add some content at the end of the bar. 

<br>

CupertinoNavigationBar trailing에 AppBar의 actions처럼

```
IconButton(icon: Icon(Icons.add), onPressed: () => _startAddNewTransaction(context))
```

IconButton을 추가하면 에러가 발생하는데, 그 이유는 IconButton Widget이 material widget을 필요로 하기 때문이다. 
IconButton widget requires a material widget ancestor. The problem is that we added an IconButton widget which is defined for material design inside of our CupertinoNavigationBar, inside our CupertinoPageScaffold. 
As the error message tells us, material widgets and the IconButton is one of them look for some parent widgets somewhere which implements material design and that's missing here.
But there is no CupertinoIconButton, one thing we can do is we can build our own button. we can add a GestureDetector instead of IconButton.

GestureDetector에는 child 프로퍼티에 Icon 위젯을 사용한다. Icon is not a material design. so we could use icons.add.

```
child: Icon(Icons.add) -- X
```

but actually to have that full iOS look. we might want to use CupertinoIcons which exists at

<br>

### 3) MainAxisSize
이 상태로 두면 CupertinoNavigationBar에서 title은 보이지 않고 + 버튼만 보이는데, 이는 + 버튼이 속해있는 Row가 모든 영역을 차지하기 때문이다.
이를 해결하기 위해 Row의 mainAxisSize 프로퍼티에 MainAxisSize.min을 추가한다


By default, it takes all the width it cant get as a row and column takes all the height it can get.
You can restrict and set it to MainAxisSize.min.
if you set it to min, the row will shrink along its main axis, so from left to right, to be only as big as its children need to be and therefore now. 

```
CupertinoNavigationBar(
  middle: Text('Personal Expenses', style: TextStyle(fontFamily: 'Open Sans'),),
  trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      GestureDetector(
        child: Icon(CupertinoIcons.add),
        onTap: () => _startAddNewTransaction(context),
      )
    ],),
)
```

This is now the default iOS look and it's not that green appBar.

<image src="./images/ios_look.png" width="300">

But that's not really looking that good, the chart is now below our navigation bar. 
so somehow this calculation of the navigation bar height is not working out correctly.

<br><br>

## 13. Using the SafeArea
that simply means that some of the available space on the screen is reserved and can't be used for positioning the widgets.
we can use a special widget which is built into Flutter, the **SafeArea** Widget.
We simply Wrap our body, in this case the SingleChildScrollView, with that widget.
This menas that make sure everything is positioned within the boundaries or moved down a bit, moved up a bit so that we consider these reserved areas on the screen. now everyting is positioned correctly.

<image src="./images/safearea.png" width="300">

<br><br>

## 14. More Cupertino Styles

<image src="./images/more_cupertino_style.png" width="500">

The reason for that is that since we're now in a CupertinoPageScaffold, we don't automatically get a theme assigned to our text here. A suolution can be to also switch our general app widget, which we have all the way at the top of the main.dart file, here the material app for a Cupertino app widget.

iOS 일 때는 MaterialApp 대신 CupertinoApp으로 render 되도록 변경한다.
- ThemeData는 CupertinoThemeData로 변경한다.

<br><br>

## 15. Using Cupertino Buttons
**CupertinoTextField** : we can also replcae the text fields with Cupertino text fields.  
**CupertinoButton**: instead of FlatButton

----

- https://stackoverflow.com/questions/49704497/how-to-make-flutter-app-responsive-according-to-different-screen-size?rq=1
- [More on LayoutBuilder](https://api.flutter.dev/flutter/widgets/LayoutBuilder-class.html)
- [All cupertino widget](https://flutter.dev/docs/development/ui/widgets/cupertino)
