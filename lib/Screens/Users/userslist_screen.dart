import 'dart:convert';
import 'dart:io';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:cookcal/HTTP/users_operations.dart';
import 'package:cookcal/HTTP/login_register.dart';
import 'package:cookcal/Screens/Users/userProfile_screen.dart';
import 'package:cookcal/Status_code_handling/status_code_handling.dart';
import 'package:cookcal/Utils/api_const.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Widgets/myProgressbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

import '../../Utils/custom_functions.dart';
import '../../WebRTC/utils/AutoReconnectWebSocket.dart';
import '../../Widgets/neomoprishm_box.dart';
import '../../Widgets/searchBar.dart';

class UserListScreen extends StatefulWidget {
  final int? curr_id;
  const UserListScreen({Key? key, required this.curr_id}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  var ws = AutoReconnectWebSocket(Uri.parse(wbapiURL+ '/users/ws'), "Users");
  UsersOperations userOp = UsersOperations();
  final myController = TextEditingController();

  bool isLoading = false;
  List<UserOut> users = [];
  late int? curr_id = widget.curr_id;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  initState(){
    super.initState();
    myController.addListener(searchControllerListener);
    ws.sink.add(myController.text);
  }

  load_data() async {
    var response = await userOp.get_all_users(myController.text);
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('user_id');

    if (response == null || response.statusCode != 200){
      return response;
    }

    List<UserOut> users_data = List<UserOut>.from(response.data.map((x)=> UserOut.fromJson(x)));
    users.removeWhere((element) => element.id == id);

    print(users_data);
    print(users_data.runtimeType);
    users.clear();
    users_data.forEach((element) {
      users.add(element);
      print(element.id);
    });

    return response;

  }

  ws_load_data(var ws_users) async {
    List<UserOut> users_data = List<UserOut>.from(ws_users.map((x)=> UserOut.fromJson(x)));
    users.removeWhere((element) => element.id == curr_id);
    users.clear();
    users_data.forEach((element) {
      String name = element.first_name.toLowerCase() + " " + element.last_name.toLowerCase();
      if (name.contains(myController.text.toLowerCase())){
        users.add(element);
        print(element.id);
      }
    }
    );
    print(users);
  }

  void searchControllerListener() {
    print(myController.text);
    ws.sink.add(myController.text);
    ws.startReconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_WHITE,
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(builder: (context, constraints){
        return Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: RoundedSearchInput(
                    hintText: 'Search here',
                    textController: myController,
                  ),
                ),
                addVerticalSpace(constraints.maxHeight * 0.02),
                /*ButtonTheme(
                  minWidth: 500,
                  height: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300,40),
                        primary: COLOR_DARKPURPLE,
                        shadowColor: Colors.grey.shade50,
                        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                        )
                    ),
                    onPressed: () {
                      ws.sink.add(myController.text);
                    },
                    child: Text('Search other Users'),
                  ),
                ),*/
                addVerticalSpace(constraints.maxHeight * 0.017),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  width: constraints.maxWidth,
                  height: constraints.maxHeight *0.01,
                  decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 2,10),
                ),
                Expanded(
                    child: StreamBuilder(
                      stream: ws.stream,
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.data != null){

                            var data = json.decode(snapshot.data);
                            if (myController.text == ""){
                              APICacheDBModel cacheDBModel = new APICacheDBModel(key: "Users", syncData: json.encode(data));
                              APICacheManager().addCacheData(cacheDBModel);
                            }

                            ws_load_data(data['detail']);

                        }
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: users.length,
                          itemBuilder: (context, index){
                            final user = users[index];
                            return Padding(padding: EdgeInsets.all(5),
                              child: Container(
                                  decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 4, 10),
                                  child: ListTile(
                                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                                    onTap: () async {
                                      ImageProvider? uImage = await userOp.get_user_image(user.id);
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserProfileScreen(user: user, uImage: uImage)));
                                    },
                                    leading: CircleAvatar(
                                      backgroundColor: COLOR_WHITE,
                                      backgroundImage: AssetImage(user_icons[user.gender]), // no matter how big it is, it won't overflow
                                    ),
                                    title: Text('${user.first_name} ${user.last_name}'),

                                  )
                              ),
                            );
                          },
                        );
                      },

                    )
                )
              ],),
            myProgressBar(isLoading)
          ],
        );
      }
      ),
    );
  }
}
