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