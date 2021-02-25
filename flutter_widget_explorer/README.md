# Widgets, Styling, Adding Logic Building a Real App

## 1. An Overview of the Core Flutter Widgets

<image srg="./images/most_important_widget.png" width="700">

### 1) MaterialApp/CupertinoApp
 - Typically the root widget in your app
 - Does a lot of "behind-the-screens" setup work for your pap
 - Allows you to configure a global theme for your app
 - Sets up navigation behavior(e.g. animations) for your app
 

### 2) Scaffold/CupertinoPageScaffold
 - Typically used as a frame for a page in your app
 - Provides a background, app bar, navigation tabs
 - Only use one scaffold per page

That is the widget that gives you a white background that allows you to add an app bar. So that is the frame for what you see on the page. and it's a crucial widget for setting up the reset of the page.


### 3) Container
 - Extremely versatile widget
 - Can be sized(width, height, maxWidth, maxHeight), styled(border, color, shape)
 - Can take a child (but doesn't have to) which you also can align in different ways

a nice widget that gives us a lot of different styling and alignment options so that we can align a child inside of it but the container is a very versatile widget where we can also give it a background color. you will often use it as a wrapper around other widgets to get a certain styling or certain alignment.


### 4) Row/Column
 - Must-use if you need multiple widgets sit next to each other horizontally or vertically
 - Limited styling options => Wrap with a Container(or wrap child widgets) to apply styling
 - Children can be aligned along main-axis and cross-axis(see seperate cheat sheet)

<br><br>

<image srg="./images/layout_and_children.png" width="700">

besides these layout widgets, we also have specific widgets that work together with row and column.

in there, you can have different child widgets but when it comes to how much space each widget should consume, there are widgets that is flexible and expanded.
Basically these are widgets which you would wrap around a child, like a text widget for example, to configure how much space this child widget should consume in the wrapping row or column.
both flexible and expanded can be used in both row and column widgets. 

<br><br>

<image src="./images/content_container.png" width="700">

### 5) Stack
 - Used to position item on top of eatch other(along the Z axis)
 - Widgets can overlap
 - You can position items in absolute space(i.e. in a coordinate space) via the Positioned() widget

### 6) Card
 - A container with some default styling(shadow, background color, rounded corners)
 - Can take one child(can be anything)
 - Typically used to output a single piece / group of information

<br><br>

<image src="./images/repeat_elements.png" width="700">

### 7) ListView/GridView
 - Used to output lists(or grids) of items
 - Like a Column() but scollable (Column is not)
 - Can be laid out vertically (default) and horizontally
 - Use ListView.builder() to get optimized item rendering for very long lists

### 8) ListTile
inside ListView, you could use a ListTile widget. It's just a widget that comes with some default styling and some default positioning or layout setup.

 - A pre-styled continer / Row() that allows you to achieve a typical "list-item-look"
 - Offer various slots for widgets(e.g. at the beginning, a title, at the end)
 - Not a must-use but can be handy for a default list-item look

### 9) Text
 - A widget that simply outputs some text on the screen
 - Text can be styled(font-family, font-weight, font size)
 - Text behavior can be conrtolled(e.g. clipping if it's too long)

### 10) Image
 - Used to render an image on the screen
 - Supports different sources(included in app, web image..)
 - Can be configured to size itself in different ways into a wrapping container

### 11) Icon
 - Render an Icon onto the screen
 - There also is an IconButton() widget in case you need a button with an icon

 <br><br>

<image src="./images/user_input.png" width="700">

### 12) TextField
 - Renders an editable text field where the user can enter (type) information
 - many configuration options(e.g. autocorrection, error messages, labels, styles)
 - Support different kinds of keyboard(email, number, normal text..)

### 13) RaisedButton / FlatButton / IconButton
 - Differently styled buttons that handle user taps
 - A custom function that should execute upon a tap can (and has to be) provided
 - Can be styled / customized

### 14) GestureDetector / InkWell
 - GestureDetector allows you to wrap ANY widget with touch listeners(e.g. double tap, long tap)
 - InkWell does the same but adds a visual ripple effet upon touch (effect can be configured)
 - You can build your own buttons / touchable widgets with these widgets

 <br><br>

 ## 2. Combining Widgets

 ### 1) Card
 card has by default depends on the size of its child. so it we want to change the size of that card, then we neetd to change the size of child.
 Text is widget by default only takes as much space as this text needs, and if you want to change the size of text, you need to change the size of its parent. 

 ```
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter App'),
      ),
      body: Column(children: <Widget>[
        Card(
          child: Text('CHART'),
          elevation: 5, // 높이
        ),
        Card(
          child: Text('LIST')
        )
      ],)
    );
  }
 ```

 How can we increase the overall size of the card? 
 - One is that we wrap that text(child widget) with a widget where we can set a size : we can wrap the text with a container. becuase container is the most universal styling positioning, sizing widget. With a container, you can control almost anything when it comes to how someting is sized or how something is aligned and styled. 

 ```
    Column(
        children: <Widget>[
            Card(
                color: Colors.blue,
                child: Conteinr(
                    width: double.infinity,
                    child: Text('CHART')
                )  // 높이
            ),
            Card(
                child: Text('LIST')
            )
        ],)
 ```

 - Two we can add a container around card with refactoring tool

 ```
    Column(
        children: <Widget>[
            Container(
                width: double.infinity,
                child: Card(
                    color: Colors.blue,
                    child: Text('CHART')  // 높이
                ),
            ),
            Card(
                child: Text('LIST')
            )
        ],)
 ```

 card now does not take the width of its child but since it has a parent that sets a clearly defined size, card actually takes the parent as a mesurement and takes the width of the parent.
 (column has by default depends on the size of its child too.)

 <br>

 ### 2) Column & Row

 <image src="./images/column_and_row.png" width="700">
 
 How you want to position the items that you have inside your column and row.

 for a column, the main axis by default is from top to bottom, cross axis is from left to right.
 for a row, the main axis is left to right and the cross axis is top to bottom

 
 ### 3) Alignments

 <image src="./images/alignment.png" width="700">

 <br>

 ### 4) Flexible & Expanded

 <image src="./images/flexible_and_expanded.png" width="700">

 <br>

 <image src="./images/flexible_and_expanded2.png" width="700">


 <br><br>

 ## 3. Container vs Column vs Row

 <image src="./images/container_vs_column_vs_row.png" width="700">

 container takes exactly one child widget and the columns and rows on the opposite take multiple.
 another difference is that a container, unlike column and row, gives you rich alignment and styling options. you can add a decoration with this seperate BoxDecoration object where you can add a border, a border. and you can add margin and padding to a container, you can align things in the container.
 On column and row, you also have alignment options, on the cross and main axis but you have no styling options.
 if you want to give a column a border, that's not possible with the column alone.

 for the container, you also have a lot of options for the width. for example, Flexible Width.
 by default it takes the child width but it also takes the available parent width if you hava a parent with a fixed widget.

 a column always takes the full available height and a row takes the full available width.

 You can combine them together, wrap a column in a container or use a container in a column or in a row. and you can mix and match effect.

 <br><br>

## 4. Using String interpolation
${transaction,.amount}, $transaction 식으로 사용한다.

```
Text("\$${transaction.amount}")
```

<br><br>

## 5. Installing External Packages && Formatting Dates
[pub.dev](https://pub.dev/) 사이트에서 필요한 패키지를 검색할 수 있다.
pub.dev is an important page in the Dart and Flutter universe. it's a site, a webpace, where you find a lot of packages you can install into your Dart projects.

we're now use intl package and intl stands for internationalisation. this package helps us with localizing our app, we could for example transform strings to different text fot the different locales.

you can just copy that dependency code part and add this to your package's pubspect.yaml.
because pubspect.yaml is file which manage the sepup of your project and most importantly, the dependencies of your project.

<br><br>

## 6. Adding Text Input Widgets (TextField)
TextField widget is responsible for receiveing user input. 

<br><br>

## 7. Fetching User Input
**TextEditingController** is a class provided by Flutter and you can assign such a controller to your text fields with the help of the controller argument. Flutter automatically conntects to controllers with TextField and these controllers listen to the user input and safety user input.


```
TextField(
    decoration: InputDecoration(labelText: 'Title'),
    controller: titleController,
),

FlatButton(
    child: Text('Add Transaction'), 
    textColor: Colors.purple,
    onPressed: (){
        print(titleController.text)
    },
)
```

<br><br>

## 8. Splitting the App into Widgets
Normally you don't have changeable properties in a stateless widget because you can't upate UI based on this changes anyways.

StatefulWidget rebuild when you changes something, so you should split your app so that you don't rebuild your entire widget tree.
이 엡에서는 사용자가 Transaction을 새로 입력하는 창은 rebuild 할 필요가 없다.


<br><br>

## 9. Making the List Scrollable
soft keyboard가 올라오면 boundary error가 발생하는데 이를 해결하기 위해 main.dart Column 위젯을 SingleChildScrollView로 wrapping 해보자.

<br><br>

## 10. Working with ListViews.
a column and a row by default is not scrollable. so of course, you could always wrap your columns and rows with SingleChildScrollView.
Flutter has a shorcut here. Instead of manually adding that SingleChildScrollView, use a **ListView** Widget.
ListView is a widget by Flutter which is by default a column with a SingleChildScrollView.
you can set a scrollDirection in case you need a row instead of a column, a scrollable row. 

ListView is basically a widget that has an infinite height. Unlike a column which takes all the height it can get on the given screen, a ListView does not have a fixed height.
It can't have a fixed height because it's scrollable. 
Flutter doesn't know How to size that ListView. so you need to give it some constraints, some settings on how much height it should take.
If you have a container around your ListView, you have exactly that kind of constraint you need.

ListView는 height를 지정해 주어야 함. 기본적으로 ListView는 height 값으로 infinity를 갖기 때문에 'Vertical viewport was given unbounded height.' 에러가 발생할 수 있음. 이를 방지하려면 height 지정이 필요.

There are actually two kind of ListViews or two ways of using it. 
The ListView widget can be used by passing a children argument to its constuctor and then you have a list of child widget.
The alternative way of using the ListView is to use the builder constructor. That's an extra constuctor on the ListView class.

but That ListView works differently.

<image src="./images/listview.png" width="700">


**ListView(children:[])** : this have child widgets and ListView is like a column with a SingleChildScrollView around it. therefore it's able to have more items than we have space on the screen. because it has an infinite height or width.

**ListView.builder()** : it generally works similarly but there we have no wrapping SingleChildView. but instead we have some optimizations put in place by Flutter. To be precise, the ListView.builder() only renders the widgets that are visible.

with ListView where you pass children as an argument, all the widgets that are part of the ListView are rendered even if they're offscreen.
For short lists, that's no problem but for very large lists, that means that you consume a lot of memory, a lot of performance for items that aren't even visible.

if you scroll such a long list, you can have lags and bad performance because Flutter needs to manage all these items in memory even though you might not be seeing them right now.

The idea with the ListView.builder() is that Flutter actually gets rid of all the items which are currently not visible and only shows you what's visible. so the parts that are not on the screen are not loaded or not rendered to be precise and this therefore is the solution and the approach you should use for very long lists or for lists where you don't know how many items will be on it. 

```
ListView.builder(
    itemBuilder: 
)
```

<br><br>

## 11. Adding AppBar buttons & Floating Action Buttons

```
 return Scaffold(
    appBar: AppBar(
    title: Text('Flutter App'),
    actions: [
        IconButton(icon: Icon(Icons.add), onPressed: (){})
    ],
    body: ....,
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    floatingActionButton: FloatingActionButton(child: Icon(Icons.add), onPressed: (){},),
    ),
 );
```

## 12. Showing a Modal Bottom Sheet

builder is a function that needs to return the widget that should be inside of that modal bottom sheet.
The builder function itself also gives us a context and make this clear that this is not the same value as this context. 
BuildContext ctx we pass to the function to pass it to the modal bottom sheet, The modal bottom sheet then starts building that shet that slides in and 
to that builder, it again gives us its own context, so its own package of meta information about that widget which it builds. 

```
void startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(context: ctx, builder: (bCtx){});
}
```

<br><br>

## 13. Improving & Styling the Modal Bottom Sheet
현재까지 실습은 Modal Bottom Sheet에 NewTransaction 위젯을 render 시켰다. 하지만 NewTransaction에서 새로운 데이터를 등록해도 TransactionList 위젯에 추가가 되지 않는 현상이 발생한다.

A widget being re-evaluated means that any internally stored data is reset and then lost. That's why we lose our user input in StatelessWidget. 
becuase whenever it is re-evaluate by flutter, for whatever reason, we lost the state that stored in there, we lose our data that's stored in there.

And for a StatefulWidget, that's different. we have that separate state object, that State Class and while the widget also would be re-evaluated by flutter, the state kind of detach from this. and data stored in that state will not be lost if the widget that belongs to it is reevaluated by flutter.

<br>

You can access the properties and methods of your **widget** class instead of StateClass 
It's only available in state classes and gives you access to the connected widget.

```
class NewTransaction extends StatefulWidget {
  final Function addNewTransaction;
  NewTransaction(this.addNewTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {

  void submitData(){
    ...

    widget.addNewTransaction(
      enteredTitle,
      enteredAmount
    );
  }

  @override
  Widget build(BuildContext context) {
    ...
  }

```

<br><br>

## 14. Configuring & Using Themes

### 1) Theme
to set up a global application-wide theme and theme basically means a combination of colors, of text style, of font size that entire application uses, that many of Flutter's widgets then use as a default. 

**primarySwatch** : The difference is that the primary color is one single color like blue or red and the primary swatch is based on one single color but it automatically generates different shades of that color automatically. many of FLutter's default widgets need these different shades and if you only defind your primary color not the swatch, then these shades are not available and therefore all these Flutter widgets will fallback to other defaults or use your primary color is look worse.

so you should define a primary swatch there and what you pass there is still a single color though, all these shades are then generated automatically based on the color


**accentColor** : besides the primary swatch, you'll often also have an accentColor. The accentColor like the name suggests is an alternative color becuase often you want to mix colors 

```
return MaterialApp(
    theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        accentColor: Colors.amber
    )
)
```

<br><br>

## 15. Custom Fonts & Working with Text Theme
First of all you need to create a new folder in your project folder so no into lib forder.
Typically you name it something like assets or you directly name it fonts whatever you want.

to include font file in our app, you need to go to pubspect.yaml file which is your global management tool. in pubspect.yaml file you should commented out area which already gives you an example of how to add fonts. so you can simply comment back in by removing the hash symbols.

If you're adding a new fonts and you're downloading that from some resource like Google Fonts which is a web page then there you should find some information about which weight your font has.

```
[pubspect.yaml]
  fonts:
    - family: OpenSans
      fonts:
        - asset: assets/fonts/OpenSans-Regular.ttf
        - asset: assets/fonts/OpenSans-Bold.ttf
          weight: 700
    - family: Quicksand
      fonts:
        - asset: assets/fonts/Quicksand-Regular.ttf
        - asset: assets/fonts/Quicksand-Bold.ttf
          weight: 700
        
```

you can set such a global font in your theme, in the ThemeData you can set a fontFamily and you can set this to Quicksand

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
        fontFamily: 'Quicksand'
      ),
      home: MyHomePage(),
    );
  }
  ...
}
```

AppBar Title TextStyle을 바꾸는 두가지 방법

- on this text widget, you could add a style and that would be a text style. (Scaffold AppBar Title에 직접 적용 - locally)

```
[main.dart]

class _MyHomePageState extends State<MyHomePage> {
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Expenses', style: TextStyle(fontFamily: 'Open Sans'),),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: () => startAddNewTransaction(context))
        ],
      ),
      body: ...
    )
  }
}
```

- MaterialApp에 appBarTheme을 설정한다(globally)

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
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
            fontFamily: 'Open Sans',
            fontSize: 18,
            fontWeight: FontWeight.bold
          )),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'Open Sans', 
              fontSize: 20,
              fontWeight: FontWeight.bold
            ), 
          )
        ),
      ),
      home: MyHomePage(),
    );
  }
}
```

위에서 global로 설정한 textTheme을 다른데서 사용하고 싶다면 아래와 같이 설정한다

```
Text(
 '텍스트',
  Theme.of(context).textTheme.headline6
)

```

<br><br>

## 16. Adding Images to the App

### 1) 프로젝트 내에 있는 이미지 가져오기

**Image.asset()**: it's provided as an asset in our project. you need to include image path in pubspect.yaml file
**Image.file()**: file would be good for image that are in files that you obtained in a different ways
**Image.network()**: if you have a URL for the image, so it it's not stored as part of your project  

### 2) BoxFit enum

<image src="./images/boxfit_1.png" width="700">

<image src="./images/boxfit_2.png" width="700">

<image src="./images/boxfit_3.png" width="700">

<br><br>

## 17. Creating Bars for our Chart

### 1) Stack
Stack widget allows you to place elements on top of each other, top is mean in like a three dimensional space. really overlapping each other. 

<br><br>

## 18. fold()

return a new value which will be added to this starting value, for every run on every item in groups. 
we received two arguments - the first argument is the currently calculated sum, the second argument is the element

```
double get maxSpending {
  return groupTransactionValue.fold(0.0, (sum, item) => sum + item['amount']);
}
```

<br><br>

## 19. Flexible

```
  Flexible(
    fit: FlexFit.tight,
    child: ChartBar(data['day'], data['amount'], totalSpending == 0.0 ? 0.0 : (data['amount'] as double) / totalSpending)
  )
```

<br><br>

## 20. FittedBox
FittedBox widget forces it child into the available space. and if that child is a text, it even shrinks the text.  
So it creates a widget that scales and positions its child withing itself


<br><br>

## 21. Padding
if you only need padding property, just use Padding widget.

<br><br>

## 22. Flexible & Expanded
**Flexible**
inside of a column or a row, every item is just as big as need to be. however you want to tell an item to take up more space in that row or column than it would normally take.
and you can do that by wrapping it with a widget named Flexible.

- fit : default is FlexFit.loose. It means that the child of that flexible item basically should keep its size and use that size in the surrounding row or column. 
other option is FlexFit.tight. It is force the child to fill the available space. 

- flex: if we hava 5 and 2 here, this means this is 5 to 2 in terms of how much space it takes. we have a total of seven segments into which the available remaining space is split up and one container takes 5 of these 7 segments, the other container has 2 of these 7 segments.  

**Expanded** is simply flexible with Flexfit.tight and therefore, expanded has no fit argument, instead expanded only knows the flex configuration which we used on flexible.
So if you need Flexible.tight, instead of using flexible with that configuration, you could simply use expanded instead. 

```
Expanded(
  flex: 5,
)
```

<br><br>

## 23. Adding a ListTile widget
ListTile built into FLutter and and that's a nicely preconfigured and styled widget with a certain layout that fits particularly well into List.
in ListTile you can set up a leading widget which means a widget that is positioned at the beginning of that ListTile 

<br><br>

## 24. Widgets & Configuring Widgets - Summary / Overview
- Padding
- CircleAvatar : replaced with a container which you manually turn into a circle shape. 아래 코드처럼 Container로도 대체할 수는 있음.

```
Container(
  height: 60,
  width: 60,
  decoration: BoxDecoration(
    color: Theme.of(context).primaryColor,
    shape: BoxShape.circle
  ),
),
```

<br><br>

## 25. Date Selection
Flutter에서 제공해주는 함수

context argument는 showDatePicker를 호출하는 클래스가 State 클래스이므로 이미 context를 global로 가지고 있어, context를 그냥 넘겨주면 된다.
in that state class which is connected to our new transaction widget, we have that global context property, so we can just use that.

```
showDatePicker(context: null, initialDate: null, firstDate: null, lastDate: null);
```

<br><br>

## 26. Future
showDatePicker()는 return 값으로 Future<DateTime>를 전달한다.
Future is class that allow us to create object which will give us a value in the future.
So you use future for example also for HTTP requests where you need to wait for response to come back from the server.
here we wait for the user to pick a value, so show date picker, immediately when we call it returns a future but it can't immediately give us the date the user picked right because we just opened the picker, we don't know when the user is going to choose a date and click.  

on a future we can add the 'then' method. 'Then' simply allows us to provide a function which is executed once the future resolves to a value,


더 많은 정보는 [위젯 카탈로그](https://flutter-ko.dev/docs/development/ui/widgets)를 참조.