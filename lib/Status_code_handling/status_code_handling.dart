
import 'dart:convert';

import 'package:cookcal/Screens/Users/userSettings_screen.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Widgets/mySnackBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

String loginEx = "Login expired please log in again";
String unknowError = "Something went wrong, check you network status";

food_weight_curruser_handle(context, code_food, code_weight, code_user){

  if (code_food == null || code_weight == null || code_user == null) {
    return false;
  }

  code_weight = code_weight.statusCode;
  code_food = code_food.statusCode;
  code_user = code_user.statusCode;

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

  if (code_user == null) {
    mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);

    return false;
  }

  code_user = code_user.statusCode;

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

  if (code_weight == null || code_user == null) {
    return false;
  }

  code_weight = code_weight.statusCode;
  code_user = code_user.statusCode;

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

image_handle(context, StreamedResponse? resp, var state) async{

  if (resp == null) {
    mySnackBar(context, Colors.red, COLOR_WHITE,'Failed to upload. Check your network connection.', Icons.cloud_off_rounded);
    //image = null;
    state.image = null;
  }
  else {
    if (resp.statusCode == 415 || resp.statusCode == 413){
      Response r_resp = await Response.fromStream(resp);
      Map<String, dynamic> rBody = jsonDecode(r_resp.body) as Map<String, dynamic>;
      mySnackBar(context, Colors.red, COLOR_WHITE,'Failed to upload. Reason: ' + rBody['detail'], Icons.cloud_off_rounded);
      //image = null;
      state.image = null;
    }
    else
    {
      mySnackBar(context, COLOR_DARKMINT, COLOR_WHITE,'Picture successfully uploaded', Icons.check_circle);
    }
  }

}

foodlist_del_handle(context, response){
  if (response == null){
    mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);
    return false;
  }

  response = response.statusCode;

  if (response == 204){
    return true;

  } else if (response == 401){
    Navigator.pop(context);
    mySnackBar(context, Colors.red, COLOR_WHITE, loginEx, Icons.close);
    return false;

  } else {
    mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);
    return false;
  }

}

foodlist_show_handle(context, response){
  if (response == null){
    mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);
    return false;
  }

  response = response.statusCode;

  if (response == 200){
    return true;

  } else if (response == 401){
    Navigator.pop(context);
    mySnackBar(context, Colors.red, COLOR_WHITE, loginEx, Icons.close);
    return false;

  } else {
    mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);
    return false;
  }
}


add_food_handle(context, response){
  if (response == null){
    mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);
    return false;
  }

  response = response.statusCode;

  if (response == 200){
    return true;

  } else if (response == 401){
    Navigator.pop(context);
    mySnackBar(context, Colors.red, COLOR_WHITE, loginEx, Icons.close);
    return false;

  } else {
    mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);
    return false;
  }
}

user_search_handle(context, response){
  if (response == null){
    mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);
    return false;
  }

  response = response.statusCode;

  if (response == 200){
    return true;

  } else if (response == 401){
    Navigator.pop(context);
    mySnackBar(context, Colors.red, COLOR_WHITE, loginEx, Icons.close);
    return false;

  } else {
    mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);
    return false;
  }

}


update_user_handle(context, response){
  if (response == null){
    mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);
    return false;
  }

  response = response.statusCode;

  if (response == 200){
    return true;

  } else if (response == 304){
    mySnackBar(context, Colors.red, COLOR_WHITE, "No data to modify", Icons.close);
    return false;

  }else if (response == 401){
    Navigator.pop(context);
    mySnackBar(context, Colors.red, COLOR_WHITE, loginEx, Icons.close);
    return false;

  } else {
    mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);
    return false;
  }

}

add_weightmeasurement_handle(context, response){
  if (response == null){
    mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);
    return false;
  }

  response = response.statusCode;

  if (response == 200){
    return true;

  } else if (response == 401){
    Navigator.pop(context);
    mySnackBar(context, Colors.red, COLOR_WHITE, loginEx, Icons.close);
    return false;

  } else {
    mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);
    return false;
  }
}

get_all_recipes_handle(context, response){
  if (response == null){
    mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);
    return false;
  }

  response = response.statusCode;

  if (response == 200){
    return true;

  } else if (response == 401){
    Navigator.pop(context);
    mySnackBar(context, Colors.red, COLOR_WHITE, loginEx, Icons.close);
    return false;

  } else {
    mySnackBar(context, Colors.red, COLOR_WHITE, unknowError, Icons.close);
    return false;
  }
}