import 'package:cookcal/HTTP/users_operations.dart';
import 'package:cookcal/HTTP/login_register.dart';
import 'package:cookcal/Screens/Users/userProfile_screen.dart';
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
    var tmp = await userOp.get_all_users(myController.text);
    print(tmp);
    print(tmp.runtimeType);
    users.clear();
    tmp?.forEach((element) {
      users.add(element);
      print(element.id);
    });
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
                  print(myController.text);
                  await load_data();
                  setState(() {});
                  print('set has been stated');
                  myController.text = "";
                },
                child: Text('Search other Users'),
              ),
            ),
            addVerticalSpace(constraints.maxHeight * 0.017),
            const Divider(
              color: COLOR_DARKPURPLE,
              thickness: 2,
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
                              SharedPreferences prefs = await SharedPreferences.getInstance();
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
