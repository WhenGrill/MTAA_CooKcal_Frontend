/*
* Kod prevzaty z
*  https://stackoverflow.com/questions/55503083/flutter-websockets-autoreconnect-how-to-implement
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

class AutoReconnectWebSocket {
  final Uri _endpoint;
  final int delay;
  final String Key;
  bool isConnected = false;
  final StreamController<dynamic> _recipientCtrl = StreamController<dynamic>();
  final StreamController<dynamic> _sentCtrl = StreamController<dynamic>();

  IOWebSocketChannel? webSocketChannel;

  get stream => _recipientCtrl.stream;

  get sink => _sentCtrl.sink;

  AutoReconnectWebSocket(this._endpoint, this.Key,{this.delay = 5}) {
    _sentCtrl.stream.listen((event) {
      webSocketChannel!.sink.add(event);
    });
    _connect();
  }

  startReconnect(){
    if (isConnected == false){
      _connect();
    }
  }

  void _connect() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (isConnected == false){
      webSocketChannel = IOWebSocketChannel.connect(_endpoint, headers: {HttpHeaders.authorizationHeader: token});
      isConnected = true;
    }
    webSocketChannel!.stream.listen((event) {
      _recipientCtrl.add(event);
    }, onError: (e) async {
      _recipientCtrl.addError(e);
      isConnected = false;
      if (e.toString().contains("Network is unreachable")){
        var CacheInstance = await APICacheManager().isAPICacheKeyExist(Key);
        if (CacheInstance){
          var DataCache = await APICacheManager().getCacheData(Key);
          _recipientCtrl.add(DataCache.syncData);
        }
      }

    }, onDone: () async {
      isConnected = false;
    }, cancelOnError: true);
  }
}