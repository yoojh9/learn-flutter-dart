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