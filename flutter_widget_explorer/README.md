# Widgets, Styling, Adding Logic Building a Real App

## 1. An Overview of the Core Flutter Widgets

<image srg="./images/most_important_widget.png" width="600">

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

<image srg="./images/layout_and_children.png" width="600">

besides these layout widgets, we also have specific widgets that work together with row and column.

in there, you can have different child widgets but when it comes to how much space each widget should consume, there are widgets that is flexible and expanded.
Basically these are widgets which you would wrap around a child, like a text widget for example, to configure how much space this child widget should consume in the wrapping row or column.
both flexible and expanded can be used in both row and column widgets. 

<br><br>

<image src="./images/content_container.png" width="600">

### 5) Stack
 - Used to position item on top of eatch other(along the Z axis)
 - Widgets can overlap
 - You can position items in absolute space(i.e. in a coordinate space) via the Positioned() widget

### 6) Card
 - A container with some default styling(shadow, background color, rounded corners)
 - Can take one child(can be anything)
 - Typically used to output a single piece / group of information

<br><br>

<image src="./images/repeat_elements.png" width="600">

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

<image src="./images/user_input.png" width="600">

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

 <image src="./images/column_and_row.png" width="500">
 
 How you want to position the items that you have inside your column and row.

 for a column, the main axis by default is from top to bottom, cross axis is from left to right.
 for a row, the main axis is left to right and the cross axis is top to bottom

 
 ### 3) Alignments

 <image src="./images/alignment.png" width="500">

 <br>

 ### 4) Flexible & Expanded

 <image src="./images/flexible_and_expanded.png" width="500">

 <br>

 <image src="./images/flexible_and_expanded2.png" width="500">


 <br><br>

 ## 3. Container vs Column vs Row

 <image src="./images/container_vs_column_vs_row" width="500">

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

<image src="./images/listview.png" width="500">


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






