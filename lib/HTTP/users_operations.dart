import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Widgets/mySnackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:cookcal/Utils/api_const.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/users.dart';

class UsersOperations {

  Future<List<UserOut>?>get_all_users(String name) async {
    try {
      Dio d = Dio();
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var id = prefs.getInt('user_id');
      d.options.headers['authorization'] = 'Bearer ' + token!;
      Response response = await d.get(apiURL + '/users/?name=' + name);
      print(response.data);

      List<UserOut> users = List<UserOut>.from(response.data.map((x)=> UserOut.fromJson(x)));
      users.removeWhere((element) => element.id == id);
      // List<UserOut> users = (response.data).map((e) => UserOut.fromJson(e)).toList();
      print(users);
      return users;
    }
    catch (e){
      print(e);
      return null;
    }
  }



  get_current_user_info() async {
    final prefs = await SharedPreferences.getInstance();
    int id = prefs.getInt('user_id')!;
    var response = await get_one_user(id);
    return response;
  }

  get_one_user(int id) async {
    try {
      Dio d = Dio();

      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      d.options.headers['authorization'] = 'Bearer ' + token!;

      Response response = await d.get(apiURL + '/users/' + id.toString());

      print(response.data);

      return response;
    }
    on DioError catch (e) {
      return e.response;
    }
  }

  get_user_image(int? id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      if (id != null) {
        Dio d = Dio();
        d.options.headers['authorization'] = 'Bearer ' + token!;

        Response response = await d.get(apiURL + '/users/' + id.toString() + '/image/');
        print(response.statusCode);
        if (response.statusCode != 200){
          return null;
        } else {
          ImageProvider? img = NetworkImage(
              apiURL + '/users/' + id.toString() + '/image/',
              headers: {'authorization': 'Bearer ' + token});
          return img;
        }
      } else {
        return null;
      }
    }
    catch (e) {
      return null;
    }
  }

  upload_user_image(File pickedImage) async {
    String filePath = pickedImage.path;

    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var id = prefs.getInt('user_id');

    var uri = Uri.parse(apiURL + '/users/' + id.toString() + '/image');
    var request = http.MultipartRequest("PUT", uri);

    request.headers['authorization'] = 'Bearer ' + token!;

    request.files.add(http.MultipartFile.fromBytes(
        'prof_picture',
        await pickedImage.readAsBytes(),
        filename: filePath.split('/').last,
        contentType: MediaType('image', filePath.split('.').last))
    );

      var response = await request.send(); //.then((response) {
        if (response.statusCode == 200)
        {
          print("Uploaded!");
          return response;
        }
        else if (response.statusCode == 415 || response.statusCode == 413){

              return response;
        }
        else
        {
          return null;
        }
      //});
  }

  Future<Map<String, dynamic>?>update_user_data(Map<String, dynamic> upUserData) async{
    try {
      Dio d = Dio();
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var id = prefs.getInt('user_id');
      d.options.headers['authorization'] = 'Bearer ' + token!;

      Map<String, dynamic> tmp =  Map<String, dynamic>.from(upUserData);
      for (var x in tmp.entries) {
        if (x.value == null) {
          upUserData.remove(x.key);
        }
      }
      print(upUserData);
      if (upUserData.isNotEmpty) {
        Response response = await d.put(apiURL + '/users/' + id.toString(),
        data: upUserData);
        print(response.statusCode);
        return upUserData;
      }

      return null;
    }
    catch (e){
      print(e);
      return null;
    }
  }

  delete_user_account() async{
    Dio d = Dio();
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var id = prefs.getInt('user_id');
    d.options.headers['authorization'] = 'Bearer ' + token!;
    Response response = await d.delete(apiURL + '/users/' + id.toString());
    print(response.statusCode);
  }

  get_curr_user_id() async {
    final prefs = await SharedPreferences.getInstance();

    int? id = prefs.getInt('user_id');
    return id;
  }

}