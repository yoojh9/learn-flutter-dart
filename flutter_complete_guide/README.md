# Flutter Basics - Widgets & How Apps Are Built

## 1. Module Introduction

### 1) What's In This Section?
- How a Flutter App Starts & Works
- Working with Widgets & Building Custom Widgets
- Reacting to User Events
- Stateless & Stateful Widgets
- Dart Fundamentals

### 2) Creating a New Project

```
$ flutter create flutter_complete_guide
```

## 2. An Overview of the Generated Files & Folders
- .idea : holds some configuration for Android Studio.
- .vscode: extra configuration for your vscode
- android: complete android project as you could also create it without Flutter. when your Flutter code gets compiled to native code, it will basically get injected into this Android project which later will be built into a real Android app
- build: output of your Flutter application. You shouldn't change anything in there, that will all be done automatically by the Flutter SDK 
- ios: for the most part this is a passive folder which gets kind of merged with your Flutter code in the end and which will all be menaged by the Flutter SDK to get iOS application
- lib: where we will do 99% of our work. It is the folder where we will add all our Dart files
- test: automated test, 
- .gitignore 
- .metadata: managed automatically by Flutter. save some information by Flutter
- .packages generated automatically by Flutter SDK. you should not delete it
- [project_name].iml: it's also managed automatically by the Flutter SDK. it manage some internal dependencies and some settings for your project
- pubspec.lock
- pubspec.yaml: allows you to mostly manage these dependencies of your project. you can configure which other third-party packages. you can also configure some other things in here, like for example fonts or images you want to use 

<br><br>


## 3. Building an App From Scratch

### 1) Flutter is All about Widgets

Every Flutter app you're building is just a bunch of widgets.
widgets are the UI building blocks, things like the app bar, maybe some image or a list with list items.
widgets also often contain other widgets like that list which has list items.

Flutter app is tree of widgets which has a root widget and in there, you have other widgets which yet might hold other widgets 


<img src="./images/flutter_widgets.png" width="700">

<br>

To create a widget, we need to create a class. becuase a widget is a special type of class.

<br><br>

## 4. Building a Widget Tree
Flutter controls the entire UI, all the pixels on the screens are controlled by your flutter app

### 1) Scaffold
it will give you a basic design and structure and color scheme or coloring for giving you a UI that looks more like a regular mobile app page.
Scaffold also has a couple of named arguments. 


<br><br>

## 5. visible(Input/Output) & invisible(Layout/control) Widgets

### 1) invisible Widgets
- we don't see invisible widgets but which help us with structuring our content.
- this widgets give our app structure and control how visible widgets are drawn onto the screen

### 2) Different Types of Widgets

<img src="./images/flutter_widgets.png" width="700">

<br><br>


## 6. Updating Correctly with Stateful Widgets 
Using StatelessWidget is incorrectly

<br> 

### 1) Understanding 'State'
In general, state is Data / Information used by your app
that state will change in an application. 
**StatelessWidget** can't have state.


<br>

<img src="./images/flutter_widgets.png" width="600">

<br>

### 2) Stateless vs Stateful
**stateless widget**
has build method which is used to render the UI.
we can pass in data from outside into the stateless widget through the constuctor of that widget class.
when external data change and actually Flutter app would rebuild.
but inside of the widget class, the data will never change.
we can only receive new data from outside and that will basically rebuild the widget.

**stateful widget**
has build method that builds a widget and that renders a UI.
we can get our input data, so data passed in through the constructor of the widget.
but we also can have some internal state.
user interface will get updated by Flutter whenever either that external, that input data changed or when our internal state changed.

state를 변경하기 위해서는 setState({})를 사용한다.

<img src="./images/stateless_vs_stateful.png" width="700">

<br>

### 3) setState
setState is a function that forces Flutter to re-render the user interface, however not the entire user interface of the entire app.
instead what set state does is calls build again of the widget.

rebuild but to not really render the entire UI again, so it does not redraw every pixel agin.
It just has its tools and its machanisms to find out what changed on the screen and what needs to be redrawn. and therefore it will find out that text here changed, that this widget changed and it will only update this text here in the end.

when you call set state, build is getting called and that is why you see the change.
That is also why you didn't see anything without set state because then you changed the data


<br><br>


## 6. Using private properties
State 클래스의 이름에 \_를 붙이면 public class에서 private class로 변경할 수 있다.
_MyAppState는 main.dart 파일 내에서만 접근 가능하며, MyApp 클래스에서만 접근할 수 있다.

이는 변수에도 적용되는데, 같은 파일 내에서만 접근할 수 있게 하고 싶다면 접두사로 \_를 붙이면 된다. 이는 Class의 private property와 같다.
마찬가지로 함수에도 적용할 수 있다. (private function)
