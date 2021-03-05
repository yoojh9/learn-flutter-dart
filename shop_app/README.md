# State Management

## 1. Grid & Item Widget

### 1) GridView
The item builder defines how every grid item is built, how every grid cell should be built.

The **gridDelegate** allows us to define how the grid generally should be structured, so how many coulmns it should have.
and we set that by providing a SliverGridDelegate and then I'll use with FixedCrossAxisCount which means I can define that I want to have a certain amount of columns and it will simply squeeze the items onto the screen so that this criteria is met.
The alternative would be the SliverGridDelegateWithFixedExtent which we used earlier, we can define how wide every grid item should be and it will then create as many columns as it can for the given device size.

```
[product_overview_screen.dart]

GridView.builder(
    padding: const EdgeInsets.all(10.0),
    itemCount: loadedProducts.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, 
        childAspectRatio: 3/2, 
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
    ), 
    itemBuilder: (ctx, index) => ProductItem(
        loadedProducts[index].id, 
        loadedProducts[index].title, 
        loadedProducts[index].title
    ),
),
```

```
[product_item.dart]

 class ProductItem extends StatelessWidget {

   final String id;
   final String title;
   final String imageUrl;

   ProductItem(this.id, this.title, this.imageUrl);

   @override
   Widget build(BuildContext context) {
     return GridTile(
       child: Image.network(imageUrl, fit: BoxFit.cover,),
       footer: GridTileBar(
         leading: IconButton(icon: Icon(Icons.favorite), onPressed: (){}),
         backgroundColor: Colors.black45,
         title: Text(title, textAlign: TextAlign.center,),
         trailing: IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){},),
        ),
     );
   }
 }
```

our goal there will be don't manage all our state in the main.dart file and pass all the state as arugments to other widget.
