import 'package:cookcal/Screens/home_screen.dart';
import 'package:cookcal/Screens/Login_register/register_screen.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:cookcal/Widgets/neomoprishm_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:provider/provider.dart';

import '../../HTTP/login_register.dart';
import '../../model/users.dart';
import '../MainNavigation_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final UserOut user;
  final ImageProvider? uImage;
  const UserProfileScreen({Key? key, required this.user, required this.uImage}) : super(key: key);
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late UserOut user = widget.user;
  late ImageProvider? uImage = widget.uImage;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('CooKcal'),
          centerTitle: true,
          backgroundColor: COLOR_VERYDARKPURPLE,
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Container(
            color: COLOR_WHITE,
            child: Column(
              children: [

                ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: Container(
                    color: COLOR_DARKPURPLE,
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.4,
                    child: Container(
                      width: 1.0,
                      height: 1.0,
                            child:
                            CircleAvatar(backgroundImage:
                            uImage != null ? uImage! : AssetImage(user_icons[user.gender])//FileImage(File(user_icons[user.gender])) as ImageProvider))
                              , backgroundColor: Colors.transparent,))
                  ),
                ),
                Container(
                    margin: const EdgeInsets.all(10),
                    decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 4,20),
                  child: Center(
                    child: Text('${user.first_name} ${user.last_name}',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 40, color: COLOR_DARKPURPLE, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                addVerticalSpace(constraints.maxHeight *0.01),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * 0.35,
                  decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 4,50),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        addVerticalSpace(constraints.maxHeight * 0.025),
                        Row(
                          children: [
                            addHorizontalSpace(constraints.maxWidth*0.07),
                            Text("Age:                                   ",
                              style: TextStyle(fontSize: 20, color: COLOR_DARKPURPLE, fontWeight: FontWeight.bold)
                            ),
                            Text("${user.age}",
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                        addVerticalSpace(constraints.maxHeight * 0.025),
                        Row(
                          children: [
                            addHorizontalSpace(constraints.maxWidth*0.07),
                            Text("Gender:                              ",
                                style: TextStyle(fontSize: 20, color: COLOR_DARKPURPLE, fontWeight: FontWeight.bold)
                            ),
                            Text("${genderItems[user.gender]}",
                                style: TextStyle(fontSize: 18)
                            ),
                          ],
                        ),
                        addVerticalSpace(constraints.maxHeight * 0.025),
                        Row(
                          children: [
                            addHorizontalSpace(constraints.maxWidth*0.07),
                            Text("State of diet:                      ",
                                style: TextStyle(fontSize: 20, color: COLOR_DARKPURPLE, fontWeight: FontWeight.bold)
                            ),
                            Text("${stateItems[user.state]}",
                                style: TextStyle(fontSize: 18)
                            ),
                          ],
                        ),
                        addVerticalSpace(constraints.maxHeight * 0.025),
                        Row(
                          children: [
                            addHorizontalSpace(constraints.maxWidth*0.07),
                            Text("Nutrition adviser:              ",
                                style: TextStyle(fontSize: 20, color: COLOR_DARKPURPLE, fontWeight: FontWeight.bold)
                            ),
                            user.is_nutr_adviser ?
                            Text("Yes",
                                style: TextStyle(fontSize: 18)
                            ) : Text("No",
                                style: TextStyle(fontSize: 18)
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ),
              ],
            ),
          );
        }),
    );
  }
}