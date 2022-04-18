import 'package:cookcal/HTTP/users_operations.dart';
import 'package:cookcal/HTTP/login_register.dart';
import 'package:cookcal/Screens/Users/userProfile_screen.dart';
import 'package:cookcal/Status_code_handling/status_code_handling.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/custom_functions.dart';
import '../../Widgets/neomoprishm_box.dart';
import '../../Widgets/searchBar.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  UsersOperations userOp = UsersOperations();
  final myController = TextEditingController();
  List<UserOut> users = [];
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_WHITE,
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(builder: (context, constraints){
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: RoundedSearchInput(
                hintText: 'Search here',
                textController: myController,
              ),
            ),
            addVerticalSpace(constraints.maxHeight * 0.02),
            ButtonTheme(
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
                onPressed: () async {
                  var response = await load_data();
                  if (user_search_handle(context, response)){
                    setState(() {});
                  }
                  myController.text = "";
                },
                child: Text('Search other Users'),
              ),
            ),
            addVerticalSpace(constraints.maxHeight * 0.017),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              width: constraints.maxWidth,
              height: constraints.maxHeight *0.01,
              decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 2,10),
            ),
            Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (context, index){
                    final user = users[index];
                    return Padding(padding: EdgeInsets.all(5),
                      child: Container(
                          decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 4, 10),
                          child: ListTile(
                            trailing: const Icon(Icons.arrow_forward_ios_rounded),
                            onTap: () async{
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
                )
            )
          ],);
      }
      ),
    );
  }
}
