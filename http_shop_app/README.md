# Sending Http Requests

## 1. What's In This Section?

<image src="./images/section_info.png" width="500">

<br><br>

## 2. Storing Data 
We basically got two options. we can store data on the device so in device storage and that kind of also includes in memomry whilist our app is running. All of that was stored in memory which is why when the app restarted, all of that progress was lost becuase the memory is reset when the app restarts.
but we also have better device storage than just memory, which is very temporary obviously, we can also store data on the device such that it persists.

The alternative to that also is storing data on a web server, so outside of the device. The data will actually persist on your device across app restarts 

<image src="./images/storing_data.png" width="700">

<br><br>

## 3. How to Connect Flutter to a Database
How can I connect Flutter to a MySQL or NoSQL or whatever in this database and with that, I mean a database that runs in the web on a server, not some on device database. The answer is you don't directly connect Flutter to your database because that's technically complex and also insecure.
Why is it insecure? If you're connecting your Flutter app directly to a database, that means that in your Flutter app code, you need to include your database credentials, your username and your password to give you read and write access to the database. 

You want to have these credentials in a place which your users have no direct access to and that would be a web server.
Therefore, you typically connect Flutter to a web server by sending HTTP requests there and then the web server in turn reaches out to a database. 

Therefore having a web server which actually stores your credentials and interacts with a database is way more secure and this is hence the approach which you want to use, you have a web server in between which establishes the connection to the database and your Flutter app only communication with that web server. 

<image src="./images/database.png" width="500">

<br><br>

## 4. Preparing Our Backend
[how to add Firebase to your Flutter app](https://firebase.google.com/docs/flutter/setup?hl=ko&authuser=0)

they do this through the Firebase SDK for Flutter which is essentially a Flutter plugin you install.

<br><br>

## 5. How To Send Http Requests
To send Http Request in Flutter, we need a specific package, the [HTTP package](https://pub.dev/packages/http) which you can easily find if you search for Flutter HTTP or pub.dev.
This is a package which makes it easy for you to send HTTP requests from inside your Flutter app.

Typically, you will communicate with a so-called REST API when working with a back-end from your Flutter app. that's the most common web server you use for front-end or for front-end applications, so for user interface like Flutter app.

<image scr="./images/http_request.png" width="700">

you might also want to update existing data and this can be done with the **patch** request which updates data or as alternative, you can send a put request which replaces data. 
The difference is that **patch** typically just edits the fields or pieces of data that changed whereas **put** take some new data block and replaces an existing one with it.

If your server supports them for the URL, for the endpoint you are sending them to and we'll now work with these HTTp verbs and also with different endpoints throughout this module.

<br><br>

## 6. Sending POST Requests
You want to have a relatively lean widget which focuses mostly on building the widget tree and then has some logic for managing its UI and the data you work with in your UI. All the heavy lifting of manipulating data, storing data and sending data to a block-end is typically not something you want to do inside of a widget, instead we could do it inside of our provider.

Now during that time whilst we wait for the response, our app execution doesn't stop, our app doesn't freeze.
when we send a HTTP request by default doesn't wait for this request to complete unless we tell it to wait.

### 1) Working with Futures in Dart
Future is core class built into Dart which builds an object which generally is a normal object but which gives us a method, the **then()** method, that allows us to wait for a certain action to finish or actually, is doesn't allow us to wait for that, it doesn't pause our entire app until this is done, instead it allows us to define a function that shuld execute in the future, 

It's a bit like registering a function for onPressed where we also simply define a function, either with a pointer at one of our functions or by adding an anonymous function which implicitly also then just passes a pointer to onpressed() which will be executed when the user presses something.

### 2) Add Product with Futures in Dart

```
[products.dart]
import 'package:http/http.dart' as http;
import 'dart:convert';  // for json convert

  void addProduct(Product product){
    const url = 'https://flutter-shop-app-a7833-default-rtdb.firebaseio.com/products.json';
    http.post(Uri.parse(url), body: json.encode({
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'isFavorite': product.isFavorite
    }),).then((response) {
      print(json.decode(response.body));

      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name']
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); //at the start of the list
      notifyListeners();
    });
  }

```

<br><br>

## 7. Futures & Async Code
Asynchronous code is code that runs and might take a bit longer and that shouldn't stop other code from continuing.
So the result of such asynchronous code will be available sometime in the future but not immediately.
it would be bad if we wait for such a HTTP request result becuase the other code would not continue executing in the meantime and your application would basically be frozen.

once your async operation finished, once that HTTP response is there for example, they remembered that they had this function saved and they are then executed for you.

```
void main() {

    var myFuture = Future(() {
        return 'Hello';
    })
    print('This runs first!');
    myFuture
        .then((result) => print(result))
        .catchError((error){
            // ....
        })
        .then((_) => print('After first then'));
    print('This also runs before the future is done!');
}

[console]
This runs first!
This also runs before the future is done!
Hello
After first then
```

this function as you see gets a result, the result of the future, even if the future doesn't return anything. **then()** also always returns a new Future. So you could add another then(.then().then()) call after this then block.

you can add chain more then blocks after each other, so this concept is called chaining.

Future can also return errors and you can handle those with catchError(). you get the error that was thrown in the end and then here, you can do whatever you need to do to handle that error, send it to your own analytics server, show an error message to the user, whatever you need to do. catchError() also returns a future, so you can call then() after a catchError(). if we had error, catchError() will catch any errors thrown by the future or by any then() block

<br><br>

## 8. Showing a Loading Indicator
