import 'package:cookcal/HTTP/users_operations.dart';
import 'package:cookcal/Screens/home_screen.dart';
import 'package:cookcal/Screens/Login_register/register_screen.dart';
import 'package:cookcal/Utils/api_const.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:regexed_validator/regexed_validator.dart';

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

  TextEditingController ipController = TextEditingController();
  TextEditingController goalweightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  late String stateChose = stateItems[user.state];
  late bool isChecked = user.is_nutr_adviser;
  late String adviserChose = adviserItems[user.is_nutr_adviser ? 0 : 1];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  UsersOperations obj = UsersOperations();

  @override
  Widget build(BuildContext context) {

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return COLOR_ORANGE;
      }
      return COLOR_GREEN;
    }

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
                      addVerticalSpace(constraints.maxHeight * 0.02),
                      const Text(
                          'Account settings',
                          style: TextStyle(fontSize: 40)
                      ),
                      addVerticalSpace(constraints.maxHeight * 0.01),
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
                      addVerticalSpace(constraints.maxHeight * 0.01),
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
                                ElevatedButton(onPressed: () async{
                                  showDialog(
                                      context: context,
                                      builder: (context){
                                        return AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                          backgroundColor: COLOR_WHITE,
                                          content: Container(
                                            width: constraints.maxWidth * 0.5,
                                            height: constraints.maxHeight * 0.38,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Column(
                                                children: [
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
                                                  addVerticalSpace(constraints.maxHeight * 0.02),
                                                  const Text(
                                                    "Do you wish to change profile picture?",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: COLOR_BLACK,
                                                        fontSize: 20
                                                    ),
                                                  ),
                                                  addVerticalSpace(constraints.maxHeight * 0.02),
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

                                                            setState(() {

                                                            });
                                                            Navigator.pop(context);
                                                          },
                                                          child: const Icon(Icons.cloud_upload),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: FloatingActionButton(
                                                    backgroundColor: COLOR_CREAME,
                                                    onPressed: () {

                                                      setState(() {

                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Icon(Icons.photo_size_select_actual),
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
                                                          child: const Icon(Icons.arrow_back),
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
                                },
                                    child: const Icon(Icons.edit_outlined),
                                    style: ElevatedButton.styleFrom(
                                        primary: COLOR_GREEN,
                                        shape: StadiumBorder())
                                )
                              ]
                          )),
                      addVerticalSpace(constraints.maxHeight * 0.005),
                      Card(
                          child: ListTile(
                            onLongPress: () {},
                            title: Text("${user.first_name} ${user.last_name}"),
                            subtitle: Text("Name & Surname"),
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
                          ),
                      ),
                      Card(
                        child: ListTile(
                          onLongPress: () {
                              setState(() {
                                showDialog(

                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                        backgroundColor: COLOR_WHITE,
                                        content:
                                        SingleChildScrollView(
                                          physics: NeverScrollableScrollPhysics(),
                                          child:
                                        Container(
                                        width: constraints.maxWidth * 0.4,
                                          height: constraints.maxHeight * 0.28,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.all(5),
                                                  child: Form(
                                                      key: _formKey,
                                                      child: TextFormField(
                                                        controller: ipController,
                                                        validator: (value) {
                                                          if (validator.ip(value!) || value == '') {
                                                            return null;
                                                          }
                                                          else{
                                                            return '        Not a valid IP address format';
                                                          }
                                                        },
                                                        decoration: InputDecoration(
                                                          filled: true,
                                                          fillColor: Colors.grey.shade200,
                                                          hintText: webrtc_ip,
                                                          focusedBorder: formBorder,
                                                          errorBorder: formBorder,
                                                          focusedErrorBorder: formBorder,
                                                          enabledBorder: formBorder,
                                                        ),
                                                      )
                                                  ),
                                                ),
                                                addVerticalSpace(constraints.maxHeight * 0.04),
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

                                                          setState(() {
                                                            if (!_formKey.currentState!.validate()){
                                                              return;
                                                            } else {
                                                              if (ipController.text != '') {
                                                                webrtc_ip = ipController.text;
                                                              }
                                                              Navigator.pop(context);
                                                            }
                                                          });

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
                                                        child: const Icon(Icons.arrow_back),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        )
                                      );
                                    }
                                );
                              });
                          },
                          title: Text(webrtc_ip),
                          subtitle: Text("WebRTC Server Address"),
                            trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.edit),
                                ])
                        ),
                      ),
                      addVerticalSpace(constraints.maxHeight * 0.05),
                      SizedBox(
                          height: 40, // <-- match-parent
                          width: 300,
                          child:  ElevatedButton(onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context){
                                  return StatefulBuilder(builder: (context, setState) {
                                  return AlertDialog(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                    backgroundColor: COLOR_WHITE,
                                    content: Container(
                                      width: constraints.maxWidth * 0.80,
                                      height: constraints.maxHeight * 0.6,
                                      child: Form(
                                      key: _formKey,child: Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            const Text(
                                              "Update account information",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: COLOR_BLACK,
                                                  fontSize: 20
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(10),
                                              child: TextFormField(
                                                controller: goalweightController,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return null;
                                                  }
                                                  else if ((!RegExp(r'^[0-9]+$').hasMatch(value)) || (int.parse(value) < 5) || (!RegExp(r'^[0]+[0-9]*$').hasMatch(value))){
                                                    return 'Please enter a valid weight';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey.shade200,
                                                  icon: const Icon(
                                                    Icons.restaurant_menu,
                                                    color: COLOR_GREEN,
                                                  ),
                                                  hintText: 'Goal Weight',
                                                  focusedBorder: formBorder,
                                                  errorBorder: formBorder,
                                                  focusedErrorBorder: formBorder,
                                                  enabledBorder: formBorder,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(10),
                                              child: TextFormField(
                                                controller: heightController,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return null;
                                                  }
                                                  else if ((!RegExp(r'^[0-9]+$').hasMatch(value)) || (int.parse(value) < 40) || (int.parse(value) > 300) || (!RegExp(r'^[0]+[0-9]*$').hasMatch(value))){
                                                    return 'Please enter a valid height';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey.shade200,
                                                  icon: const Icon(
                                                    Icons.accessibility_new_outlined,
                                                    color: COLOR_GREEN,
                                                  ),
                                                  hintText: 'Height in CM',
                                                  focusedBorder: formBorder,
                                                  errorBorder: formBorder,
                                                  focusedErrorBorder: formBorder,
                                                  enabledBorder: formBorder,
                                                ),
                                              ),
                                            ),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              const Text(
                                                "State:",
                                                textScaleFactor: 1.2,
                                              ),
                                              addHorizontalSpace(15),
                                              DropdownButton<String>(
                                                alignment: Alignment.center,
                                                dropdownColor: Colors.grey.shade200,
                                                value: stateChose,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black
                                                ),
                                                items: stateItems.map((valueItem) {
                                                  return DropdownMenuItem<String>(
                                                    value: valueItem,
                                                    child: Text(valueItem),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    stateChose = newValue!;
                                                  });
                                                },
                                              ),
                                            ]
                                        ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                const Text(
                                                  "Nutr. adviser:",
                                                  textScaleFactor: 1.2,
                                                ),
                                                addHorizontalSpace(15),
                                                DropdownButton<String>(
                                                  alignment: Alignment.center,
                                                  dropdownColor: Colors.grey.shade200,
                                                  value: adviserChose,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black
                                                  ),
                                                  items: adviserItems.map((valueItem) {
                                                    return DropdownMenuItem<String>(
                                                      value: valueItem,
                                                      child: Text(valueItem),
                                                    );
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    adviserChose = newValue!;
                                                    setState(() {

                                                    });

                                                  },
                                                ),
                                              ],
                                            ),
                                            addVerticalSpace(constraints.maxHeight * 0.04),
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

                                                      setState(() {
                                                        if (!_formKey.currentState!.validate()){
                                                          return;  // TODO Returning future as this is async !!
                                                        } else {
                                                          Map<String, dynamic> upUserData = {
                                                            "goal_weight": ((goalweightController.text == '') ? null : double.parse(goalweightController.text)),
                                                            "height": ((heightController.text == '') ? null : double.parse(heightController.text)),
                                                            "state": ((stateChose == stateItems[user.state]) ? null : stateItems.indexOf(stateChose)),
                                                            "is_nutr_adviser": ((adviserChose == adviserItems[user.is_nutr_adviser ? 0 : 1]) ? null : !user.is_nutr_adviser)
                                                          };
                                                          print(upUserData);

                                                          // await obj.update_user_data(upUserData);
                                                          Navigator.pop(context);
                                                        }
                                                      });

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
                                                    child: const Icon(Icons.arrow_back),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                    ),
                                  );});
                                }
                            );
                          },
                              child: const Text('Edit account',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                  primary: COLOR_GREEN,
                                  shape: StadiumBorder())
                          )
                      ),
                      addVerticalSpace(constraints.maxHeight * 0.015),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.red.shade700),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                  backgroundColor: COLOR_WHITE,
                                  content: Container(
                                    width: constraints.maxWidth * 0.4,
                                    height: constraints.maxHeight * 0.24,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          const Text(
                                            "Do you wish to delete your account?",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: COLOR_BLACK,
                                                fontSize: 20
                                            ),
                                          ),
                                          Text('!! This action is irreversible !!',
                                              style: TextStyle(color: Colors.red.shade700, fontSize: 18)),
                                          addVerticalSpace(constraints.maxHeight * 0.04),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: FloatingActionButton(
                                                  backgroundColor: Colors.red.shade700,
                                                  onPressed: () async {
                                                    try {
                                                      await obj.delete_user_account();
                                                      setState(() {
                                                      });
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    } catch (e) {
                                                      setState(() {
                                                      });
                                                      print(e);
                                                    }
                                                  },
                                                  child: const Icon(Icons.delete_forever_rounded),
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
                                                  child: const Icon(Icons.arrow_back),
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
                        },
                        child: const Text('Delete account',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                            fontWeight: FontWeight.bold)
                        ),
                      ),
                      addVerticalSpace(constraints.maxHeight * 0.015)
                    ])
            ),
          );
        }
        )
    );
  }
}
