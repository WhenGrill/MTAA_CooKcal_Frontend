import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints)
    {
      return Container(
          color: COLOR_BLACK,
          child: Stack(
            children: [
              Positioned.fill(
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.asset('assets/images/welcome_background.png',
                        fit: BoxFit.cover
                    ),
                  )
              ),
              Center(
                child: Column(
                  children: [
                    addVerticalSpace(constraints.maxHeight * 0.1),
                    ClipOval(
                      child: Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        color: COLOR_WHITE,
                        child: Image.asset('assets/images/logo.png',
                            fit: BoxFit.cover
                        ),
                      ),
                    ),
                    addVerticalSpace(constraints.maxHeight * 0.1),
                    Text(
                        "Welcome Back!",
                        textAlign: TextAlign.center,
                      style: TextStyle(
                        color: COLOR_WHITE,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    addVerticalSpace(constraints.maxHeight * 0.05),
                    Text(
                      "We are glad you continue your diet journey",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: COLOR_WHITE,
                        fontSize:17,
                      ),
                    )
                  ],
                ),
              )
            ],
          )
      );
    })
    );

  }
}