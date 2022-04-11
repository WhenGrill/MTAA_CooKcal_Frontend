import 'package:cookcal/Utils/constants.dart';
import 'package:flutter/material.dart';

import '../Utils/custom_functions.dart';
import '../Widgets/searchBar.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints){
        return Column(
          children: [
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
                    fixedSize: const Size(150,50),
                    primary: COLOR_GREEN,
                    shadowColor: Colors.grey.shade50,
                    textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                    )
                ),
                onPressed: () {
                  print(myController.text);
                },
                child: Text('Search'),
              ),
            ),
            addVerticalSpace(constraints.maxHeight * 0.02),
            const Divider(
              color: COLOR_GREEN,
              thickness: 2,
            ),
            Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index){
                    final user = users[index];
                    return Card(
                        child: ListTile(
                          onTap: () {},
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
