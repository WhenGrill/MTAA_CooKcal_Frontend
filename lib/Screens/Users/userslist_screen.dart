import 'package:cookcal/HTTP/all_users.dart';
import 'package:cookcal/HTTP/login_register.dart';
import 'package:cookcal/Screens/Users/userProfile_screen.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Utils/custom_functions.dart';
import '../../Widgets/searchBar.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final myController = TextEditingController();
  List<UserOut> users = [];
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  load_data() async {
    var tmp = await UsersOperations().get_all_users(myController.text);
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
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(builder: (context, constraints){
        return Column(
          children: [
            addVerticalSpace(constraints.maxHeight * 0.02),
            RoundedSearchInput(
              hintText: 'Search here',
              textController: myController,
            ),
            addVerticalSpace(constraints.maxHeight * 0.02),
            ButtonTheme(
              minWidth: 500,
              height: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300,40),
                    primary: COLOR_GREEN,
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
                },
                child: Text('Search other Users'),
              ),
            ),
            addVerticalSpace(constraints.maxHeight * 0.017),
            const Divider(
              color: COLOR_GREEN,
              thickness: 2,
            ),
            Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (context, index){
                    final user = users[index];
                    return Card(
                        child: ListTile(
                          trailing: const Icon(Icons.arrow_forward_ios_rounded),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserProfileScreen(user: user)));
                          },
                          leading: CircleAvatar(
                            backgroundColor: COLOR_WHITE,
                            backgroundImage: AssetImage(user_icons[user.gender]), // no matter how big it is, it won't overflow
                          ),
                          title: Text('${user.first_name} ${user.last_name}'),

                        )
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
