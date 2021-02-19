# Flutter Introduction


## 1. What is Flutter?

A 'tool' that allows you to build **native cross-platform**(iOS, Android) apps with one programming language(dart) and codebase.

- SDK: collection of tools that allows you to write one codebase or use one codebase with one programming language
- A Framework / Widget Library: vast collection of reusable UI building blocks (=widgets), build user interfaces with these tools.

![flutter](./images/flutter.png =500x)


### 1) Dart?
Focused on frontend(mobile apps, web) user interface(UI) development.
Programming language developed by Google


### 2) Flutter vs Dart
flutter builds up on dart.
it's a framework for Dart and Dart actually is the programming launage which we're using.
Flutter is just a collection of tools, a set of features, utility functions and these widgets which are implemented using dart

![flutter](./images/flutter_and_dart.png =500x)

<br><br>

## 2. Flutter Architecture

![flutter](./images/flutter_architecture.png =500x)

### 1) Everything's Widget!
flutter is everything's a widget.

![flutter](./images/flutter_widget.png =500x)

### 2) Your App's UI is a Widget Tree!

![flutter](./images/flutter_widget_tree.png =500x)


## 3. How is Flutter / Dart "transformed" to a Native App?
![flutter](./images/flutter_compile.png =500x)


### 1) Flutter Does NOT use Platform Primitives
Flutter directly controls every pixel on the screen. 
so Flutter does not compile your code to some native equivalence or native alternatives, 
instead Flutter ships with its own engine which controls the entire screen, 
everything the user sees and render every pixel on its own and that gives Flutter a lot of control and a lot of flexibility

![flutter](./images/flutter_platform.png =500x)


<br><br>

## 3. Flutter macOS setup
https://flutter-ko.dev/docs/get-started/install/macos 참고


## 4. Flutter & Material Design

### 1) Materfial Design Everywhere

![flutter](./images/material_design.png =500x)

Material is a Design System created(and heavily used) by Google.
It's NOT Google's style for Everyone!
It is indeed highly customizable(and works on iOS devices, too)
Material Design is built into Flutter but you also find Apple-styled (Cupertino) widgets


## 5. Flutter vs React Native vs Ionic

![flutter](./images/flutter_compare.png =500x)
