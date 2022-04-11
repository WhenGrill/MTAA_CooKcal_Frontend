import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/main.dart';
import 'package:flutter/material.dart';
import 'package:cookcal/Screens/home_screen.dart';
import 'package:cookcal/Screens/Recipes/recipeslist_screen.dart';
import 'package:cookcal/Screens/Users/userslist_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int current_index = 1;

  final screens = [
    RecipeListScreen(),
    HomeScreen(),
    UserListScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CooKcal'),
        centerTitle: true,
        backgroundColor: COLOR_GREEN,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.settings))
        ],
      ),
      body: screens[current_index],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          backgroundColor: COLOR_GREEN,
          selectedItemColor: COLOR_ORANGE,
          iconSize: 27,
          showUnselectedLabels: true,
          currentIndex: current_index,
          onTap: (index) => setState(() {
            current_index = index;
          }),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.fastfood),
                backgroundColor: COLOR_GREEN,
                label: 'Recipes'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                backgroundColor: COLOR_GREEN,
                label: 'Home'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                backgroundColor: COLOR_GREEN,
                label: 'Users'
            )
          ]
      ),
    );
  }
}