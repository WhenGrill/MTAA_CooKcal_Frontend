import 'package:cookcal/Screens/home_screen.dart';
import 'package:cookcal/Screens/Login_register/register_screen.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../HTTP/login_register.dart';
import '../../model/users.dart';
import '../MainNavigation_screen.dart';

class UserSettingsScreen extends StatefulWidget {
  final UserOneOut user;
  const UserSettingsScreen({Key? key, required this.user}) : super(key: key);
  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  late UserOneOut user = widget.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: Text('CooKcal'),
            centerTitle: true,
            backgroundColor: COLOR_GREEN),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child:
              Container(
                color: COLOR_WHITE,
                child: Column(
                    children: [
                      addVerticalSpace(40),
                      const Text(
                          'Account settings',
                          style: TextStyle(fontSize: 40)
                      ),
                      addVerticalSpace(10),
                      const Divider(
                        color: COLOR_BLACK,
                        //color of divider
                        height: 5,
                        //height spacing of divider
                        thickness: 3,
                        //thickness of divier line
                        indent: 25,
                        //spacing at the start of divider
                        endIndent: 25, //spacing at the end of divider
                      ),
                      addVerticalSpace(5),
                      Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Profile Picture'),
                                Container(
                                  width: 105.0,
                                  height: 105.0,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/man.png'),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                ElevatedButton(onPressed: () {},
                                    child: const Icon(Icons.edit_outlined),
                                    style: ElevatedButton.styleFrom(
                                        primary: COLOR_GREEN,
                                        shape: StadiumBorder())
                                )
                              ]
                          )),
                      addVerticalSpace(5),
                      Card(
                          child: ListTile(
                            onLongPress: () {},
                            title: Text("${user.first_name} ${user.last_name}"),
                            subtitle: Text("Meno a Priezvisko"),
                          )
                      ),
                      Card(
                          child: ListTile(
                            onLongPress: () {},
                            title: Text("${user.email} "),
                            subtitle: Text("E-mail"),
                          )
                      ),
                      Card(
                          child: ListTile(
                            onLongPress: () {},
                            title: Text("${user.age} "),
                            subtitle: Text("Age"),
                          )
                      ),
                      Card(
                          child: ListTile(
                            onLongPress: () {},
                            title: Text("${user.height} cm"),
                            subtitle: Text("Height"),
                          )
                      ),
                      Card(
                          child: ListTile(
                            onLongPress: () {},
                            title: Text("${genderItems[user.gender]} "),
                            subtitle: Text("Gender"),
                          )
                      ),
                      Card(
                          child: ListTile(
                            onLongPress: () {},
                            title: Text("${user.goal_weight} kg"),
                            subtitle: Text("Goal weight"),
                          )

                      ),
                      Card(
                          child: ListTile(
                            onLongPress: () {},
                            title: Text("${stateItems[user.state]} "),
                            subtitle: Text("State"),
                          )

                      ),
                      Card(
                          child: ListTile(
                            onLongPress: () {},
                            title: Text(user.is_nutr_adviser ? 'YES' : 'NO'),
                            subtitle: Text("Nutrition adviser"),
                          )

                      ),
                      addVerticalSpace(30),
                      SizedBox(
                          height: 40, // <-- match-parent
                          width: 300,
                          child:  ElevatedButton(onPressed: () {},
                              child: const Text('Edit account',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                  primary: COLOR_GREEN,
                                  shape: StadiumBorder())
                          )
                      ),
                      addVerticalSpace(15),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.red.shade700),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: const Text('Delete account',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                            fontWeight: FontWeight.bold)
                        ),
                      ),
                    addVerticalSpace(10)
                    ])
            ),
          );
        }
        )
    );
  }
}
