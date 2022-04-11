import 'package:cookcal/Screens/home_screen.dart';
import 'package:cookcal/Screens/register_screen.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../HTTP/login.dart';
import '../model/users.dart';
import 'MainNavigation_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final UserExample user;
  const UserProfileScreen({Key? key, required this.user}) : super(key: key);
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('CooKcal'),
          centerTitle: true,
          backgroundColor: COLOR_GREEN,
          actions: [
            IconButton(onPressed: (){

            }, icon: Icon(Icons.settings))
          ],
        ),
        body: Container(
          color: COLOR_WHITE,
        )
    );
  }
}