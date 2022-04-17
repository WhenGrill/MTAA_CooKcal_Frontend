import 'package:cookcal/Screens/home_screen.dart';
import 'package:cookcal/Screens/Login_register/register_screen.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:cookcal/Widgets/neomoprishm_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../HTTP/login_register.dart';
import '../../model/users.dart';
import '../MainNavigation_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final UserOut user;
  const UserProfileScreen({Key? key, required this.user}) : super(key: key);
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late UserOut user = widget.user;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('CooKcal'),
          centerTitle: true,
          backgroundColor: COLOR_DARKPURPLE,
          actions: [
            IconButton(onPressed: (){

            }, icon: const Icon(Icons.settings))
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Container(
            color: COLOR_WHITE,
            child: Column(
              children: [
                addVerticalSpace(10),

                Container(
                  width: 220.0,
                  height: 220.0,
                  decoration: BoxDecoration(
                    color: COLOR_MINT,
                    image: DecorationImage(
                      image: AssetImage(user_icons[user.gender]),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all( Radius.circular(110.0)),
                    border: Border.all(
                      color: COLOR_MINT,
                      width: 5.0,
                    ),
                  ),
                ),
                Text('${user.first_name} ${user.last_name}',
                  style: const TextStyle(fontSize: 40),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * 0.35,
                  decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 4,50)
                  //child: Text("INFO O MNE", style: TextStyle(color: COLOR_WHITE, fontSize: 50),),
                ),
              ],
            ),
          );
        }),
    );
  }
}