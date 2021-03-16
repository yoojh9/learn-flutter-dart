# Working with User Input & Forms

## 1. What's in this Section?

<image src="./images/intro.png" width="400">

<br><br>

## 2. add Snackbars 
in product_item.dart file, where we have that add to cart button, I want to show a little info popup that confirms to the user that we did add this item.
we'll use scaffold, of course we worked with scaffold before, scaffold is a widget we used to create that general page layour with an appBar. 

Now we'll not use it as a widget but we'll use the same class, but then access a static method that exists on scaffold and that's the of() method. 
and of course, we already have some exprience with that of() method. we used it on a couple of different classes, like media query, theme but also the provider and the idea always is the same. of() always takes a context and then it estabilishes some kind of connection behind teh scenes.

with **scaffold.of(context)**, we establish a connection to the nearest scaffold widget, the nearest scaffold in the product_overview_screen.dart
Now Why do we reach out to that scaffold widget in the end? Because on that scaffold widget which controls the entire page. you can do a couple of things and for example, you could open the side drawer of course this only works if the nearest scaffold you're reaching out to has a drawer.

Scaffold.of(context).showSnackBar(snackbar)는 deprecated 됨. 
**'showSnackBar' is deprecated and shouldn't be used. Use ScaffoldMessenger.showSnackBar.**

you call hideCurrentSnackBar() and if there is a snack bar already, this will be hidden before the new one is shown. now if we add an item and then we press this again, you see the snack bar gets dismissed immediately and the new snackBar comes up.
 
```
[product_item.dart]
   @override
   Widget build(BuildContext context) {
       ...
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Added item to cart!', textAlign: TextAlign.center,),
            duration: Duration(seconds: 2),
            action: SnackBarAction(
            label: 'UNDO',
            onPressed: (){
                cart.removeSingleItem(product.id);
            },
            ),
        )
    );
   }


[product_overview_screen.dart]
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    
    return Scaffold(
      appBar: AppBar(),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}


[products_grid.dart]
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavorites ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, 
        childAspectRatio: 3/2, 
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ), 
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem()
      ),
    );
  }


```

<br><br>

## 3. Showing Alert Dialog
the other dialog I want to add is in the cart_item.dart when we dismiss an item. 
for that on dismissable, we can add a **confirmDismiss** argument which takes a function and of course I'm now also working with a lot of anonymous functions. in this anonymous function, ( {Future<bool> Function(DismissDirection) confirmDismiss} ) we get the DismissDirection which was chosen and we have to return a Future. You remember that object which eventually will return a boolean result.

### 1) showDialog()
unlike the snackbar(), for this we need no scaffold because this is not attached to a page, a dialog can be shown anywhere, so it's just showDialog().
showDialog() requires a context argument because you still need to give it a context so that it knows to which widget to attach itself.
showDialog() actually does return a future though, and this future will be called whenever the dialog is closed. So actually, we can return a future but it should be a future that in the end yields true or false.

but here in onPressed(), we can control what the future resolves to by calling navigator.pop()

```
[showDialog() docs]
Returns a [Future] that resolves to the value (if any) that was passed to [Navigator.pop] when the dialog was closed.
```

So the future resolves to a value that was passed navigator.pop()

```
[cart_item.dart]

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
          ...
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog(
          context: context, 
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'), 
            content: Text('Do you want to remove the item from the cart?'),
            actions: [
              TextButton(
                child: Text('No'), 
                onPressed: (){
                  Navigator.of(ctx).pop(false); 
                }, 
              ),
              TextButton(
                child: Text('Yes'), 
                onPressed: (){
                  Navigator.of(ctx).pop(true); 
                }, 
              ),
            ],
          )
        );
      },
      onDismissed: (_){
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: ...

    )
  }

```

<br><br>

## 4. NetworkImage
on the NetworkImage, you can't set up a fit or anything like that becuase it's not a widget. it's just an object that does the fetching of the image and then forwards it to CircleAvatar through that background image argument and CircleAvatar will do the sizing itself.

<br><br>

## 5. 'Edit Product' Screen
edit_product_screen will actually be a stateful widget. Stateful we'll have to manage all that user input.
form input as a good candidate for a widget only or a local state and the reason for that is what the user entered is important for this widget because you want to validate it, you want to temporarilly store it and once the user submits that, presses some submit button, you typically want to save that into your app-wide state, create new product, sign up a user, whatever you're doing but until that submit button pressing, you want to only manage that data in your widget. your general app is not affected by the user input until it is really submitted.

So therefore, we want to manage the user input and validate it and so on locally in this widget and hence a **StatefulWidget** is the right solution, instead of using the provider pacakge and a more globally configured object.

<image src="./images/state_management.png" width="700">

<br><br>

## 6. Using Forms & Working with Form Inputs
How can we handle the user input? What's a good way of doing that? Instead of manually collecting all inputs with text editing controllers, we use form widget.
The **form** widget itself is invisible, It doesn't render somthing on the screen which you could see but inside of the form widget, you can use special input widgets which are then grouped together and which can be submitted together and validated together in very simple ways.
A form takes a simple child argument, you build your nomal widget tree but now wrapped inside that form.

In here, I first of all want to build a scrollable list of input elements and of course, for that, we can use a column with a SingleChildScrollView around it for a ListView.

And now here, instead of a TextField which we used before, we use a TextFormField and that's the special input which works together with this form. TextFormField are automatically connected to that form behind the scenes and can interact with it and you'll see how to interact with the form in just second.

thankfully you also don't have to add a controller here to get the input because the form will help you get that value and will manage it for you behind the scenes. 

```
Form(
    child: ListView(children: [
        TextFormField(
            decoration: InputDecoration(labelText: 'Title'),
            textInputAction: TextInputAction.next,
        )
    ],
)
```

<br><br>

## 7. ListView or Column
When working with Forms, you typically have multiple input fields above each other - that's why you might want to ensure that the list of inputs is scrollable. Especially, since the soft keyboard will also take up some space on the screen.

For very long form or in landscape mode, you might encounter a strange behavior: User input might get lost if an input fields scrolls out of view.

That happens because the **ListView** widfget dynamically removes and re-adds widgets as they scroll out of and back into view.

For short lists/ portrait-only apps, where only minimal scrolling might be needed, a ListView should be fine, since items won't scroll that far out of view (ListView has a certain threshold until which it will keep items in memory).

But for longer lists or apps that should work in landscape mode as well - or maybe just to be safe - you might want to use a Column (combined with SingleChildScrollView) instead. Since SingleChildScrollView doesn't clear widgets that scroll out of view, you are not in danger of losing user input in that case.

```
// ListView
Form(
    child: ListView(
        children: [ ... ],
    ),
),

// Column + SingleChildScrollView
Form(
    child: SingleChildScrollView(
        child: Column(
            children: [ ... ],
        ),
    ),
),
```

<br><br>

## 8. Managing Form Input Focus
### 1) Focus Node
in our edit_product_screen, in the state object, you can add a new final property, and you create it with a value of FocusNode. FocusNode is a class built into Flutter, we instantiate it here and we store that focus node in the price focus node key in that property.

the FocusNode can be assigned to a TextInput widget. when this next button is pressed, you can listen to onFieldSubmitted, This will fire whenever next button is pressed, There you get the value that entered in the field, now we can use that FocusNode to move the focus form the first, form that title input to the second, to the price input.

For that we use another class named **FocusScope** which is also built into Flutter and made available with material.dart import and FocusScope works a bit like theme and mediaQuery. You use of(context) to connect it to the page, then you have a **requestFocus()** method and this takes a focus node.
So we pass the _priceFocusNode and with that, we tell Flutter that when this first input is submitted, so when this next button is pressed in the soft keyboard, we actually want to focus the element with the _priceFocusNode and we assign that _priceFocusNode to the second text form field. 

Now I press the next button whilst the focus is on the title, you see it automatically moves to the price and that's nice user experience.

```
[edit_product_screen.dart]

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(children: [
            TextFormField(
               decoration: InputDecoration(labelText: 'Title'),
               textInputAction: TextInputAction.next,
               onFieldSubmitted: (value){
                 FocusScope.of(context).requestFocus(_priceFocusNode);
               },
            ),
            TextFormField(
               decoration: InputDecoration(labelText: 'Price'),
               textInputAction: TextInputAction.next,
               keyboardType: TextInputType.number,
               focusNode: _priceFocusNode,
            ),
          ],
          )
        ),
      ),
    );
  }
}
```

<br><br>

## 9. Multiline Inputs & Disposing Objects
### 1) maxLines
to determine how long this may be, how many lines should be rendered on the screen.

### 2) keyboardType: TextInputType.multiline
which gives us a keyboard that is particularly suited for multiline text input.
I do remove the TextInputAction.next because multiline will automatically give us an enter symbol in the bottom right corner of the soft keyboard so that we can enter a new line.
Hence we also don't need onFieldSubmitted there because the user will have to move to the next input on his own because we can't tell when he's done because we'll have an enter symbol to simply add a new line.

```
class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(children: [
            TextFormField(
               decoration: InputDecoration(labelText: 'Title'),
               textInputAction: TextInputAction.next,
               onFieldSubmitted: (value){
                 FocusScope.of(context).requestFocus(_priceFocusNode);
               },
            ),
            TextFormField(
               decoration: InputDecoration(labelText: 'Price'),
               textInputAction: TextInputAction.next,
               keyboardType: TextInputType.number,
               focusNode: _priceFocusNode,
               onFieldSubmitted: (_){
                 FocusScope.of(context).requestFocus(_descriptionFocusNode);
               },
            ),
            TextFormField(
               decoration: InputDecoration(labelText: 'Description'),
               maxLines: 3,
               keyboardType: TextInputType.multiline,
               focusNode: _descriptionFocusNode,
            ),
          ],
          )
        ),
      ),
    );
  }
}
```

### 3) Disposing Objects
one other important note about focus nodes, you have to dispose them when your state gets cleared, so when this object gets removed, when you'll leave that screen because the FocusNode will stick around memory and will lead to a memory leak.
So when working with FocusNode, you sould add a dispose method to your state class.

```
  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }
```

<br><br>

## 10. Image Input & Image Preview

아래처럼 작성 후 빌드하면 다음과 같은 에러가 발생함.

'An InputDecorator, which is typically created by a TextField, cannot have an unbounded width.
This happens when the parent widget does not provide a finite width constraint. For example, if the InputDecorator is contained by a Row, then its width must be constrained. An Expanded widget or a SizedBox can be used to constrain the width of the InputDecorator or the TextField that contains it.'

```
Row(
    children: [
        Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.only(top:8, right: 10),
            decoration: BoxDecoration(
            border: Border.all(width: 1 , color: Colors.grey)
            ),
            child: _imageUrlController.text.isEmpty 
            ? Text('Enter a URL') 
            : FittedBox(
                child: Image.network(_imageUrlController.text, fit: BoxFit.cover,),
            )
        ),
        TextFormField(
            decoration: InputDecoration(labelText: 'Image URL'),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            controller: _imageUrlController,
        ),
    ], 
)
```

we learned that an input decoration which is created by a text field cannot have an unbounded width. So we have the problem with the width of some text form field. and the problem is that the TextFormField sits inside of a Row and the TextFormField by default takes as much width as it can get and the problem with that is if it's inside of a Row as we have it here, a Row has unconstrained width. So normally, the boundaries of the device width are the boundaries of the TextFormField but the row doesn't have these boundaries, it doesn't have the device width as an internal boundary therefore TextFormField tries to take an infinite amount of width. solution is simple. we can wrap this with a new widget and there for example, we can take the **Expanded** widget. 


### 1) Expanded
A widget that expands a child of a Row, Column, or Flex so that the child fills the available space.
Using an Expanded widget makes a child of a Row, Column, or Flex expand to fill the available space along the main axis.
If multiple children are expanded, the available space is divided among them according to the flex factor.
An Expanded widget must be a descendant of a Row, Column, or Flex, and the path from the Expanded widget to its enclosing Row, Column, or Flex must contain only StatelessWidgets or StatefulWidgets



```
Expanded(
  child: TextFormField(
    decoration: InputDecoration(labelText: 'Image URL'),
    keyboardType: TextInputType.url,
    textInputAction: TextInputAction.done,
    controller: _imageUrlController,
    onEditingComplete: () {
      setState(() {});
    },
  )
),
```

### 2) onEditingComplete()
By adding the onEditingComplete listener and by calling setState() in there(even though it's empty), we force Flutter to update the screen,
hence picking up the latest image value entered by the user.

<br>

### 3) add Image Preview Listener
one thing you could want about that imageUrl is that you actually don't need to hit this button at the bottom right to see the preview
but that you also see that preview if this loses focus. 
Flutter doesn't have a default listener for when this loses focus but you can set up your own listener with the help of focus node.

So let's add a new FocusNode for the image, an _imageUrlFocusNode which we create with FocusNode class and of course, we have to dispose of that when the state object get destroyed.

And add this _imageUrlFocusNode to our TextFormField for the imageUrl because we can now set our own listener, and when this losses focus, so when the user unselected it, then we can react to this to make sure that we updated the UI and use the imageUrlController to show a preview.

so for that, we need to set up our own listener to the _imageUrlFocusNode. It's attached to that TextFormField. and therefore, it keeps track of whether that's focused or not, so we just need to listen to changes in that focus. For that, initState() is a good place to set up that initial listener. 
important, we also have to clear that listener when we dispose of that state, otherwise the listener keeps on living in memory even though the page is not presented anymore and that again creates a memory leak. to be super safe before the _imageUrlFocusNode.dispose() I would recommend that you call remove listener.

```
class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl(){
     if(!_imageUrlFocusNode.hasFocus){
       setState(() {
         
       });
     }
  }
}
```

in the _updateImageUrl(), we simply have to check if we're not having focus anymore, So if the _imageUrlFocusNode does not have focus and this will be fired if it had focus and we then click somewhere else and if we don't have focus anymore, so we lost focus then we want to update the UI and use the latest state stored in the imageUrlController and for that we can simply call setState(). It's a bit of a hack because we don't update the state ourselves but we know that the state has updated, that we have an updated value in _imageUrlController and we want to rebuild the screen to reflect that updated value in _imageUrlController since that value in _imageUrlController is the image you want to preview.

now if I pasted my URL and I then tap into a diffrent field, you see that preview, so now we get the preview when we lose focus.


<br><br>

## 11. Submitting Forms
How can we submit our form and get all the values the user entered? As mentioned before, this Form widget helps us with that but first of all, we need a trigger that actually leads to that form being submitted and I will actually go with two triggers, one of them is the **Done Button** because that's the last input. and I also want to have **save button** here in the action bar that should also try to submit the form.

I want to submit my form with the help of the Form widget to get access to all the values. for that, you need a way to interact with the Form widget.
So How can you get a direct access to that Form widget from inside code? For that, you can use **global key**

### 1) GlobalKey
You typically need it when you need to interact with a widget form inside your code. you do that with Form widgets and not really that much with other widgets. So hence, we add a new property in our state, a property that should hold that golbal key.
Globalkey can hook into the state of widgets. So GlobalKey will allow us to interact with the state behind the form widget and therefore we can assign that form key to the form to establish that connection simply by setting the key argument to form which is our global key.

Now we can use the form property to interact with the state managed by that form widget and form is StatefulWidget, it's invisible but behind the scenes, it does work with your form elements and gives you easy access to all your form values.

```
[edit_product_screen.dart]

class _EditProductScreenState extends State<EditProductScreen> {
  final _form = GlobalKey<FormState>();

  void _saveForm(){
    _form.currentState.save();
  }

  @override
   Widget build(BuildContext context) {
       return Scaffold(
           ...
           body: Form(
            key: _form,
           )
           ...
       )
   }
}
```

now with that key, with that form property which has access to this Form widget or to the state of the form widget, 
we can reach out that property to the form property and call **_form.currentState.save()** is simply a method provided by the state ogject of the Form widget, it will save that form.

_saveForm() will trigger a method on every text form field which allows you to take the value entered into the TextFormField and do with it whatever you want, for example store it into global maps collects all text inputs. 

<br><br>

## 12. Validating User Input
on every TextFormField, you can add a validator argument. Now validator takes a function which takes a value and then returns a string.
Now the value you get is the value that was currently entered into the TextFormField and the validator is executed when you call a specific validate method.

if you return null, this is treated as there is no error, the input is correct. so returning null means input is correct.
if you return a text like 'this is wrong', the text is always treated as your error text, so as the message you want to show to the user.
So if you have a validation error and you want to return null if you don't have one.

of course, it's all about comparing that value or checking that value to certain conditions you have. 
Now the good thing is such an error message will then be shown automatically.
The question is how can we now trigger validation? We can trigger it through the formKey.
when we save the form, then we can also call form current state validate and this will trigger all the validators and this will return true if they all return null 


```
[edit_product_screen.dart]

class _EditProductScreenState extends State<EditProductScreen> {

  void _saveForm(){
    final isValid = _form.currentState.validate();
    if(isValid){
      return;
    }
    _form.currentState.save();
    print(_editedProduct.title);
    print(_editedProduct.price);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar()
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(children: [
            TextFormField(
               decoration: InputDecoration(labelText: 'Title', ),
               textInputAction: TextInputAction.next,
               onFieldSubmitted: (value){
                 FocusScope.of(context).requestFocus(_priceFocusNode);
               },
               validator: (value){
                 if(value.isEmpty){
                   return 'Please provide a value';
                 } 
                 return null;
               },
               onSaved: (value){...},
            ),  
            ...
}
```

<br><br>

## 13. Adding Validation to All Inputs

### 1) price validation - tryParse
I want to check if double.parse() succeed, tryParse() is the perfect solution for that because tryParse unlike parse does not throw an error if it fails but return null if it does fail.

we know that parsing failed because tryParse returns null if it fails. Now maybe parsing succeeded but the number is smaller or equal to zero. 

```
[edit_product_screen.dart]

TextFormField(
    decoration: InputDecoration(labelText: 'Price'),
    textInputAction: TextInputAction.next,
    keyboardType: TextInputType.number,
    focusNode: _priceFocusNode,
    onFieldSubmitted: (_){
        FocusScope.of(context).requestFocus(_descriptionFocusNode);
    },
    validator: (value){
        if(value.isEmpty){
        return 'Please enter a price.';
        } 
        if(double.tryParse(value)==null){
        return 'Please enter a valid number.';
        }
        if(double.parse(value) <= 0) {
        return 'Please enter a number greater than zero';
        }
        return null;
    },
)
```

### 2) description validation

```
TextFormField(
    ...
    validator: (value){
        if(value.isEmpty){
        return 'Please enter a description.';
        }
        if(value.length < 10){
        return 'Should be at least 10 characters long.';
        }
        return null;
    },
    ...
)
```

### 3) imageUrl validation
TexrFormField의 validator argument에서 validation을 check하지 않고, _updateImageUrl() 함수에서 진행해본다.

```
  void _updateImageUrl(){
     if(!_imageUrlFocusNode.hasFocus){
        if(_imageUrlController.text.isEmpty || 
          (!_imageUrlController.text.startsWith('http') && !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') && !_imageUrlController.text.endsWith('.jpg') && !_imageUrlController.text.endsWith('.jpeg'))){
          return;
        }

       setState(() {
         
       });
     }
  }
```

<br><br>

## 14. Saving New Products
to save product, use provider. 
context is available everywhere in your State object.

```
  void _saveForm(){
    final isValid = _form.currentState.validate();
    if(isValid){
      return;
    }
    _form.currentState.save();
    Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    Navigator.of(context).pop();
  }

```