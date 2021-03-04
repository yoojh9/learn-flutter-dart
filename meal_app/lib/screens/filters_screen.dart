import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';

  final Function saveFilters;
  final Map<String, bool> filters;

  FiltersScreen(this.saveFilters, this.filters);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  bool _glutenFree = false;
  bool _vegetarian = false;
  bool _vegan = false;
  bool _lactoseFree = false;

  @override
  void initState() {
    super.initState();
    _glutenFree = widget.filters['gluten'];
    _vegetarian = widget.filters['vegetarian'];
    _vegan = widget.filters['vegan'];
    _lactoseFree = widget.filters['lactose'];
  }

  Widget _buildSwitchListTile(String title, String description, bool currentValue, Function updateValue){
    return SwitchListTile(
      title: Text(title),
      value: currentValue, 
      subtitle: Text(description), 
      onChanged: updateValue
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Filters'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: (){
            widget.saveFilters({
              'gluten': _glutenFree,
              'lactose': _lactoseFree,
              'vegetarian': _vegetarian,
              'vegan': _vegan
            });
          },),
        ],
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text('Adjust your meal selection.', style: Theme.of(context).textTheme.headline6,),
          ),
          // Expanded: it will take all the remaining space between container and the end of the screen.
          Expanded(child: ListView(
            children: [
              _buildSwitchListTile('Gluten-free', 'only include gluten-free meals', _glutenFree, (newValue){
                  setState((){
                    _glutenFree = newValue;
                  });
              }),
              _buildSwitchListTile('Lactose-free', 'only include lactose-free meals', _lactoseFree, (newValue){
                  setState((){
                    _lactoseFree = newValue;
                  });
              }),
              _buildSwitchListTile('Vegetarian', 'only include vegetarian meals', _vegetarian, (newValue){
                  setState((){
                    _vegetarian = newValue;
                  });
              }),
              _buildSwitchListTile('Vegan', 'only include vegam meals', _vegan, (newValue){
                  setState((){
                    _vegan = newValue;
                  });
              }),
            ],
          ))
        ],
      ),
    );
  }
}