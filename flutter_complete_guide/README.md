# Flutter Basics - Widgets & How Apps Are Built

## 1. Module Introduction

### 1) What's In This Section?
- How a Flutter App Starts & Works
- Working with Widgets & Building Custom Widgets
- Reacting to User Events
- Stateless & Stateful Widgets
- Dart Fundamentals

### 2) Creating a New Project

$ flutter create flutter_complete_guide


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

