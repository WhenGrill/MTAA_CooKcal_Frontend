import 'dart:convert';

import 'package:cookcal/Utils/api_const.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/users.dart';

class GetAllUsers {

  Future<List<UserOut>?>get_all_users(String name) async {
    try {
      Dio d = Dio();
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      d.options.headers['authorization'] = 'Bearer ' + token!;
      Response response = await d.get(apiURL + '/users/?name=' + name);
      print(response.data);

      List<UserOut> users = List<UserOut>.from(response.data.map((x)=> UserOut.fromJson(x)));
      // List<UserOut> users = (response.data).map((e) => UserOut.fromJson(e)).toList();
      print(users);
      // print("Jebem ti mamku v noci");
      // print("++++++++++++++++++++++++++++\n" + response.data + "\n++++++++++++++++++++++++\n");
      return users;
    }
    catch (e){
      print(e);
      return null;
    }
  }
}