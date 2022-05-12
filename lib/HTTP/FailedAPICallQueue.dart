import 'dart:collection';
import 'dart:convert';

import 'package:cookcal/Utils/api_const.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';



class FailedAPICallsQueue {
  GetStorage box = new GetStorage();
  Queue items = Queue();
  int user_id = -1;
  String token = "";

  bool get hasItems {
    return items.isNotEmpty;
  }

  bool get isEmpty {
    return items.isEmpty;
  }

  FailedAPICallsQueue(int user_id, String token) {
    this.user_id = user_id;
    this.token = token;
    this.items = _loadQueue();
  }

  Queue _loadQueue() {
    List q = box.read('queueUser${this.user_id}') ?? [];
    print(q);
    if (q.isEmpty) {
      return Queue();
    } else {
      for (var x in q){
        x['token'] = token;
      }
      return Queue.from(q);
    }
  }

  _commit() {
    box.write('queueUser${this.user_id}', items.toList());
  }

  removeAll() {
    items.clear();
  }


  delete_related_requests(Map<String, dynamic> call){
    String method = call['method'];
    List q = items.toList();

    var i = null;

    if (method == 'DELETE'){
      int id = call['id'];
      for (var x in q){
        if (x['method'] == 'POST' && x['id'] == id){
          i = q.indexOf(x);
          break;
        }
      }
      if (i != null){
        q.removeAt(i);
        this.items = Queue.from(q);
        _commit();
        return true;
      }
      return false;
    } else if (method == 'PUT'){
      int id = call['id'];
      for (var x in q){
        if (x['method'] == 'POST' && x['data']['id'] == id){
          i = q.indexOf(x);
          break;
        }
      }
      if (i != null){
        q[i]['data'] = call['data'];
      }
    }


    return false;
  }

  removeFirst(){
    var req = items.removeFirst();
    _commit();
    return req;
  }

  add(var object) {
    if(!delete_related_requests(object)) {
      items.add(object);
      _commit();
    }
  }

  execute_first() async{
    print("FailedAPICallsQueue  --  QUEUED EXECUTING !!!!!!!!");
    Future<dynamic> req = removeFirst();
    try {
      var resp = await req;
      return req;
    }
    on DioError catch (e){
      return e.response;
    }
  }

  execute_all_pending() async{
    Dio d = Dio();
    try {
      Response r = await d.get(apiURL);

      if (r.statusCode == 200){
        if(items.isEmpty){
          print("FailedAPICallsQueue  --  Nothing to process");
        }
        while (items.isNotEmpty){
          try{
            var req = removeFirst(); // items.removeFirst();

            if (req['token'] != null){
              d.options.headers['authorization'] = 'Bearer ' + req['token'];
            }

            switch (req['method']){
              case 'PUT': {
                await d.put(req['url'], data: req['data']);
              }
              break;

              case 'POST': {
                await d.post(req['url'], data: req['data']);
              }
              break;
              
              case 'DELETE': {
                await d.delete(req['url']);
              }
              break;

            }
            print("FailedAPICallsQueue  --  Request processed");
          }
          on DioError catch (e){
            print("FailedAPICallsQueue  --  Network available but request failed");
            continue;
          }
        }
      }
    }
    on DioError catch (e){
      print("FailedAPICallsQueue  --  Network error - nothing send to Backend");
      return;
    }

  }

}