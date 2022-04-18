import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_WHITE,
        body: LayoutBuilder(builder: (context, constraints)
        {
          return Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    addVerticalSpace(constraints.maxHeight * 0.1),
                    Container(
                      width: 250,
                      height: 250,
                      child: Image.asset("assets/images/logo.png"),
                    ),
                    addVerticalSpace(50),
                    Text(
                        "Special thanks to:",
                      style: TextStyle(color: COLOR_PURPLE, fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    addVerticalSpace(10),
                    Text(
                      "Johannes Milke",
                      style: TextStyle(color: COLOR_DARKMINT, fontSize: 17),
                    ),
                    addVerticalSpace(6),
                    Text(
                      "FlutterBrick",
                      style: TextStyle(color: COLOR_PURPLE, fontSize: 17),
                    ),
                    addVerticalSpace(6),
                    Text(
                      "Flaticon",
                      style: TextStyle(color: COLOR_DARKMINT, fontSize: 17),
                    ),
                    addVerticalSpace(6),
                    Text(
                      "Freepik",
                      style: TextStyle(color: COLOR_PURPLE, fontSize: 17),
                    ),
                    addVerticalSpace(6),
                    Text(
                      "Becris",
                      style: TextStyle(color: COLOR_DARKMINT, fontSize: 17),
                    ),
                    addVerticalSpace(6),
                    Text(
                      "Triangle Squad",
                      style: TextStyle(color: COLOR_PURPLE, fontSize: 17),
                    )
                  ]
              )
          );
        })
    );

  }
}