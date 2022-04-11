import 'package:cookcal/HTTP/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cookcal/Screens/home_screen.dart';
import 'package:cookcal/Screens/Login_register/login_screen.dart';
import 'package:cookcal/utils/constants.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: COLOR_GREEN));

    return ChangeNotifierProvider(create: (ctx) => Userauth(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Screen 2',
      theme: ThemeData(textTheme: defaultText),
      home: LoginScreen(),
    ),);
    /*  LayoutBuilder(builder: (context, constraints) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Screen 2',
        theme: ThemeData(textTheme: defaultText),
        home: LoginScreen(),
      );
    });
    )*/

  }
}