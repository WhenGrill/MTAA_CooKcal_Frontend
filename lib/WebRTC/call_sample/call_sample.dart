import 'package:cookcal/HTTP/login_register.dart';
import 'package:cookcal/HTTP/users_operations.dart';
import 'package:cookcal/Widgets/mySnackBar.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import '../../Utils/constants.dart';
import 'signaling.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallSample extends StatefulWidget {
  static String tag = 'call_sample';
  final String host;
  UserOneOut user;
  CallSample({required this.host, required this.user});

  @override
  _CallSampleState createState() => _CallSampleState();
}

class _CallSampleState extends State<CallSample> {
  Signaling? _signaling;
  List<dynamic> _peers = [];
  String? _selfId;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _inCalling = false;
  Session? _session;

  bool isMute = false;


  bool _waitAccept = false;

  UsersOperations UserOp = UsersOperations();
  // ignore: unused_element
  _CallSampleState();

  @override
  initState() {
    super.initState();
    initRenderers();
        _connect();
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  deactivate() {
    super.deactivate();
    _signaling?.close();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  void _connect() async {
   // mySnackBar(context, Colors.orange, COLOR_WHITE, "Trying to connect to WebRTC server...", Icons.incomplete_circle_rounded);
    //print('De je snack barik');
    _signaling ??= Signaling(widget.host, widget.user, this)..connect();
    _signaling?.onSignalingStateChange = (SignalingState state) {
      switch (state) {
        case SignalingState.ConnectionClosed:
          //mySnackBar(context, Colors.red, COLOR_WHITE, "Connection to WebRTC server failed. Check your network status.", Icons.cloud_off_rounded);
          break;
        case SignalingState.ConnectionError:
         // mySnackBar(context, Colors.red, COLOR_WHITE, "Connection to WebRTC server failed. Check your network status.", Icons.cloud_off_rounded);
          break;
        case SignalingState.ConnectionOpen:
          //mySnackBar(context, COLOR_DARKMINT, COLOR_WHITE, "Connection to WebRTC server established", Icons.check);
          break;
      }
    };

    _signaling?.onCallStateChange = (Session session, CallState state) async {
      switch (state) {
        case CallState.CallStateNew:
          setState(() {
            _session = session;
          });
          break;
        case CallState.CallStateRinging:
          bool? accept = await _showAcceptDialog();
          if (accept!) {
            _accept();
            isMute = false;
            setState(() {
              isMute = false;
              _inCalling = true;
            });
          }
          else {
            _reject();
          }
          break;
        case CallState.CallStateBye:
          if (_waitAccept) {
            print('peer reject');
            _waitAccept = false;
            Navigator.of(context).pop(false);
          }
          setState(() {
            _localRenderer.srcObject = null;
            _remoteRenderer.srcObject = null;
            _inCalling = false;
            _session = null;
          });
          break;
        case CallState.CallStateInvite:
          _waitAccept = true;
          _showInviteDialog();
          break;
        case CallState.CallStateConnected:
          if (_waitAccept) {
            _waitAccept = false;
            Navigator.of(context).pop(false);
          }
          setState(() {
            _inCalling = true;
          });

          break;
      }
    };

    _signaling?.onPeersUpdate = ((event) {
      setState(() {
        _selfId = event['self'];
        _peers = event['peers'];
      });
    });

    _signaling?.onLocalStream = ((stream) {
      _localRenderer.srcObject = stream;
    });

    _signaling?.onAddRemoteStream = ((_, stream) {
      _remoteRenderer.srcObject = stream;
    });

    _signaling?.onRemoveRemoteStream = ((_, stream) {
      _remoteRenderer.srcObject = null;
    });
  }

  Future<bool?> _showAcceptDialog() {
    return showDialog<bool?>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: COLOR_WHITE,
          title: Text("Incoming Call...", style: TextStyle(color: COLOR_PURPLE),),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.phone_in_talk, color: Colors.green,),
              onPressed: () {
                Navigator.of(context).pop(true);
              },

            ),
            IconButton(
              icon: Icon(Icons.phone_disabled, color: Colors.red,),
              onPressed: () => Navigator.of(context).pop(false),

            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showInviteDialog() {
    return showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: COLOR_WHITE,
          title: Text("Calling Nutrition adviser", style: TextStyle(color: COLOR_PURPLE),),
          content: Text("Ringing..."),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.phone_disabled, color: Colors.red,),
              onPressed: () {
                _hangUp();
                },

            ),
          ],
        );
      },
    );
  }

  _invitePeer(BuildContext context, String peerId, bool useScreen) async {
    if (_signaling != null && peerId != _selfId) {
      _signaling?.invite(peerId, 'video', useScreen);
    }
  }

  _accept() {
    if (_session != null) {
      _signaling?.accept(_session!.sid);
    }
  }

  _reject() {
    if (_session != null) {
      _signaling?.reject(_session!.sid);
    }
  }

  _hangUp() {
    if (_session != null) {
      _signaling?.bye(_session!.sid);
    }
  }

  _switchCamera() {
    _signaling?.switchCamera();
  }

  _muteMic() {
    _signaling?.muteMic();
  }

  _buildRow(context, peer) {
    var self = (peer['id'] == _selfId);
    var user = (peer['user_agent'] != 'Nutrition Adviser');
    return ListBody(children: <Widget>[
      ListTile(
        focusColor: COLOR_WHITE,
        tileColor: COLOR_WHITE,
        textColor: COLOR_PURPLE,
        title: Text(self ? peer['name'] + ' [Your self] Connected successfuly!': peer['name']), // Text(self ? peer['name'] + ', ID: ${peer['id']} ' + ' [Your self]' : peer['name'] + ', ID: ${peer['id']} '),
        onTap: null,
        trailing: SizedBox(
            width: 100.0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon((self || user) ? Icons.close : Icons.videocam,
                        color: (self || user) ? Colors.grey : COLOR_PURPLE),
                    onPressed: (){

                      if (self){
                        mySnackBar(context, Colors.red, COLOR_WHITE, 'Not allowed', Icons.close);
                      }
                      else if (user){
                        mySnackBar(context, Colors.red, COLOR_WHITE, 'Forbidden: You can only call nutrition advisers', Icons.close);
                      }
                      else {
                        _invitePeer(context, peer['id'], false);
                      }
                    },
                    tooltip: 'Video calling',
                  ),
                 /* IconButton(
                    icon: Icon((self || not_nutr_adviser) ? Icons.close : Icons.screen_share,
                        color: (self || not_nutr_adviser)? Colors.grey : Colors.black),
                    onPressed: () {
                      if (!self && !not_nutr_adviser){
                      _invitePeer(context, peer['id'], true);
                      } else{
                        mySnackBar(context, Colors.red, COLOR_WHITE, 'Call between Users is forbidden. (Only calls between Users and Nutrition advisers are prohibited)', Icons.close);
                      }
                      },
                    tooltip: 'Screen sharing',
                  )*/
                ])),
        subtitle: Text('[' + peer['user_agent'] + ']'),
      ),
      Divider()
    ]);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: COLOR_WHITE,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _inCalling
          ? SizedBox(
              width: 200.0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FloatingActionButton(
                      backgroundColor: COLOR_PURPLE,
                      child: const Icon(Icons.switch_camera, color: COLOR_WHITE,),
                      onPressed: _switchCamera,
                    ),
                    FloatingActionButton(
                      onPressed: _hangUp,
                      tooltip: 'Hangup',
                      child: Icon(Icons.call_end),
                      backgroundColor: Colors.red,
                    ),
                    FloatingActionButton(
                      backgroundColor: COLOR_DARKMINT,
                      child: isMute ? Icon(Icons.mic_off, color: COLOR_GREY) : Icon(Icons.mic, color: COLOR_WHITE),
                      onPressed: () {
                        isMute = !_muteMic();
                        setState(() {
                        });
                        },
                    )
                  ]))
          : null,
      body: _inCalling
          ? OrientationBuilder(builder: (context, orientation) {
              return Container(
                child: Stack(children: <Widget>[
                  Positioned(
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      bottom: 0.0,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: RTCVideoView(_remoteRenderer),
                        decoration: BoxDecoration(color: Colors.black54),
                      )),
                  Positioned(
                    left: 20.0,
                    top: 20.0,
                    child: Container(
                      width: orientation == Orientation.portrait ? 90.0 : 120.0,
                      height:
                          orientation == Orientation.portrait ? 120.0 : 90.0,
                      child: RTCVideoView(_localRenderer, mirror: true),
                      decoration: BoxDecoration(color: Colors.black54),
                    ),
                  ),
                ]),
              );
            })
          : ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0.0),
              itemCount: (_peers != null ? _peers.length : 0),
              itemBuilder: (context, i) {
                return _buildRow(context, _peers[i]);
              }),
    );
  }
}
