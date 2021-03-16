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
