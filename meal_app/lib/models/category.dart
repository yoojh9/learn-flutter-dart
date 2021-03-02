import 'package:flutter/material.dart';

class Category {
   final String id;
   final String title;
   final Color color;

   // const means that since all these properties are final, the properties of an object can't be changed after the object has been created 
   const Category({this.id, this.title, this.color = Colors.orange});
}