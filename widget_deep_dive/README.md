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

<image src="./images/widget-element-tree.pnt" width="700">

In our stateful widget, we call setState(), so something changes there.

This element tree which is not rebuild whenever build() is called, only the widget tree is rebuild and the element tree can automatically updates its references to know if a new configuration is available, it passes that information to the render object so that these can re-render on the screen.

calling build() does not mean that the entire screen re-renders becuase Flutter has a couple of layers to manage that and calling build or the build() being called only menas that this widget tree, so that tree of configuration data rebuild or parts of tree rebuild.
and therefore Flutter checks which parts on the real screen need to be updated.

<br><br>

## 4. How Flutter Executes build()