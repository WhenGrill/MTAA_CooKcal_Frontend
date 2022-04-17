
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Widgets/mySnackBar.dart';
import 'package:flutter/material.dart';

String loginEx = "Login expired please log in again";
String unknowError = "Something went wrong, check you network status";

food_weight_curruser_handle(context, code_food, code_weight, code_user){

  if (code_food == 200){

    if(code_weight == 200){

      if(code_user == 200){
        return true;

      }else if (code_user == 401){
        Navigator.pop(context);
        mySnackBar(context, Colors.red, COLOR_WHITE, loginEx, Icons.close);

        return false;

      }else {
        mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);
        return false;
      }

    }else if (code_weight == 401){
      Navigator.pop(context);
      mySnackBar(context, Colors.red, COLOR_WHITE, loginEx, Icons.close);

      return false;

    }else {
      mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);
      return false;

    }

  }else if (code_food == 401){
    Navigator.pop(context);
    mySnackBar(context, Colors.red, COLOR_WHITE, loginEx, Icons.close);

    return false;

  }else {
    mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);
    return false;

  }

}

user_handle(context, code_user){
  if (code_user == 200){
    return true;
  }
  else if (code_user == 401){
    Navigator.pop(context);
    mySnackBar(context, Colors.red, COLOR_WHITE, loginEx, Icons.close);

    return false;
  }
  else{
    mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);
    return false;
  }

}

weight_curruser_handle(context, code_weight, code_user){

  if (code_user == 200){

    if (code_weight == 200){

      return true;

    }else if (code_weight == 401) {
      Navigator.pop(context);
      mySnackBar(context, Colors.red, COLOR_WHITE, loginEx, Icons.close);

      return false;

    }else {
      mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);

      return false;

    }

  }else if (code_user == 401){
    Navigator.pop(context);
    mySnackBar(context, Colors.red, COLOR_WHITE, loginEx, Icons.close);

    return false;

  }else{
    mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);

    return false;
  }

}