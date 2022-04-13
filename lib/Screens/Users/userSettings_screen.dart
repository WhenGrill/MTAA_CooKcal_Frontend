import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Utils/constants.dart';
import '../../Utils/custom_functions.dart';
import '../../model/users.dart';

class UserSettingsScreen extends StatefulWidget {
  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(builder: (context, constraints) {
        return Container(
          color: COLOR_WHITE,
          child: Column(
            children: [
              addVerticalSpace(60),
              const Text(
                  'Account settings',
                  style: TextStyle(fontSize: 40)
              ),
              addVerticalSpace(10),
              const Divider(
                color: COLOR_BLACK, //color of divider
                height: 5, //height spacing of divider
                thickness: 3, //thickness of divier line
                indent: 25, //spacing at the start of divider
                endIndent: 25, //spacing at the end of divider
              ),
              addVerticalSpace(20),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Profile Picture'),
                    Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: const BoxDecoration(
                                image: DecorationImage(
                                        image: AssetImage('assets/images/man.png'),
                                        fit: BoxFit.cover),
                                ),
                    ),
                    FloatingActionButton(
                      heroTag: 'btnrecipes',
                      backgroundColor: COLOR_DARKGREEN,
                      onPressed: () {

                      },
                      child: const Icon(Icons.edit_outlined),
                    )
                  ]
              ),
            addVerticalSpace(20),
              Column(
                  children: [
                    const Text(
                        'TEST',
                        style: TextStyle(fontSize: 40)
                    ),
                    const Text(
                        'Registered: XX-XX-2022'
                    )

                  ]),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(5)
              ),
              Container(
                alignment: Alignment.center,
                child: Column(children: [
                  Text('Ahoj')
                ]),
              )
            ],
          )
        );
      }),
    );

  }
}
