import 'package:cookcal/HTTP/all_users.dart';
import 'package:cookcal/HTTP/login_register.dart';
import 'package:cookcal/Screens/Users/userSettings_screen.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/main.dart';
import 'package:flutter/material.dart';
import 'package:cookcal/Screens/home_screen.dart';
import 'package:cookcal/Screens/Recipes/recipeslist_screen.dart';
import 'package:cookcal/Screens/Users/userslist_screen.dart';

import '../Utils/custom_functions.dart';
import '../model/users.dart';

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

    return WillPopScope(
        onWillPop: () async {
          showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  backgroundColor: COLOR_WHITE,
                  content: Container(
                    width: 300,
                    height: 120,
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const Text(
                            "You are about to logout.",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: COLOR_BLACK,
                                fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Do you wish to proceed?",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: COLOR_BLACK,
                                fontSize: 20
                            ),
                          ),
                          addVerticalSpace(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: FloatingActionButton(
                                  backgroundColor: COLOR_GREEN,
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);

                                  },
                                  child: const Icon(Icons.check),
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: FloatingActionButton(
                                  backgroundColor: COLOR_ORANGE,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(Icons.close),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
          );
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('CooKcal'),
            centerTitle: true,
            backgroundColor: COLOR_GREEN,
            actions: [
              IconButton(onPressed: () async{
                UsersOperations obj = UsersOperations();
                UserOneOut user = await obj.get_current_user_info();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserSettingsScreen(user: user)));
              }, icon: Icon(Icons.settings))
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
        )
    );
  }
}