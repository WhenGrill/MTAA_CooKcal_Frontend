import 'dart:io';

import 'package:cookcal/HTTP/users_operations.dart';
import 'package:cookcal/HTTP/weight_operations.dart';
import 'package:cookcal/Screens/home_screen.dart';
import 'package:cookcal/Screens/Login_register/register_screen.dart';
import 'package:cookcal/Utils/api_const.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';


import '../../HTTP/login_register.dart';
import '../../model/users.dart';
import '../../model/weight.dart';
import '../MainNavigation_screen.dart';



class UserSettingsScreen extends StatefulWidget {
  final UserOneOut user;
  final ImageProvider? uImage;
  final int? uId;
  final String? token;
  final WeightOut? currUserWeight;

  const UserSettingsScreen({Key? key, required this.user, required this.uImage, required this.uId, required this.token, required this.currUserWeight}) : super(key: key);
  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  late UserOneOut user = widget.user;
  late ImageProvider? uImage = widget.uImage;
  late int? uId = widget.uId;
  late String? token = widget.token;
  late WeightOut? currUserWeight = widget.currUserWeight;

  TextEditingController ipController = TextEditingController();
  TextEditingController goalweightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController currweightController = TextEditingController();

  late String stateChose = stateItems[user.state];
  late bool isChecked = user.is_nutr_adviser;
  late String adviserChose = adviserItems[user.is_nutr_adviser ? 0 : 1];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  UsersOperations UserOp = UsersOperations();
  WeightOperations WeightOp = WeightOperations();

  File? image;
  ImageProvider? uImagelocal;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print("failed to pick image: $e");
    }
  }


  @override
  Widget build(BuildContext context) {

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return COLOR_MINT;
      }
      return COLOR_DARKPURPLE;
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child:
              Container(
                color: COLOR_WHITE,
                child: Column(
                    children: [
                      addVerticalSpace(constraints.maxHeight * 0.02),
                      const Text(
                          'Account settings',
                          style: TextStyle(fontSize: 40)
                      ),
                      addVerticalSpace(constraints.maxHeight * 0.01),
                      const Divider(
                        color: COLOR_BLACK,
                        //color of divider
                        height: 5,
                        //height spacing of divider
                        thickness: 3,
                        //thickness of divier line
                        indent: 25,
                        //spacing at the start of divider
                        endIndent: 25, //spacing at the end of divider
                      ),
                      addVerticalSpace(constraints.maxHeight * 0.01),
                      Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Profile Picture'),
                                Container(
                                  width: 105.0,
                                  height: 105.0,
                                  decoration: const BoxDecoration(),
                                  // child: uImage != null ? CircleAvatar(backgroundImage: uImage!) : assert_to_image(context, user_icons[user.gender])
                                  child: /*uImage != null ? CircleAvatar(backgroundImage: uImage!) : (image != null ? Image.file(image!, fit: BoxFit.cover) : (
                                      assert_to_image(context, user_icons[user.gender])))*/

                                  Container(
                                        width: 600,
                                        height: 600,
                                        color: COLOR_WHITE,
                                        child:
                                        CircleAvatar(backgroundImage:
                                        image != null ? FileImage(image!) : (uImage != null ? uImage! : FileImage(File(user_icons[user.gender])) as ImageProvider))
                                    ),


                                  /*CachedNetworkImage(
                                    imageUrl: apiURL + '/users/' + uId.toString() + '/image',
                                    placeholder: (context, url) => const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => assert_to_image(context, user_icons[user.gender]),  //// YOU CAN CREATE YOUR OWN ERROR WIDGET HERE
                                    httpHeaders: {'authorization': 'Bearer ' + token!},
                                    imageBuilder: (context, imageProvider) =>  CircleAvatar(backgroundImage: imageProvider)
                                  )*/
                                ),
                                ElevatedButton(onPressed: () async{
                                  showDialog(
                                      context: context,
                                      builder: (context){
                                        return AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                          backgroundColor: COLOR_WHITE,
                                          content: Container(
                                            width: constraints.maxWidth * 0.5,
                                            height: constraints.maxHeight * 0.38,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Column(
                                                children: [
                                                  Stack(
                                                    children: [ /* uImage != null ? CircleAvatar(backgroundImage: uImage!) : (image != null ? Image.file(image!, fit: BoxFit.cover) : (
                                                            assert_to_image(context, user_icons[user.gender]))) */

                                                     /* ClipOval(
                                                        clipper: MyClipper(),

                                                          child: image != null ? Image.file(image!, fit: BoxFit.fill) : (uImage != null ? Image(image: uImage!) : assert_to_image(context, user_icons[user.gender]))

                                                      ),*/
                                                      Container(
                                                          height: 100,
                                                          width: 100,
                                                          child:
                                                      CircleAvatar(
                                                        backgroundImage: image != null ? FileImage(image!) : (uImage != null ? uImage! : FileImage(File(user_icons[user.gender])) as ImageProvider),
                                                      ))
                                                    ],
                                                  ),
                                                  addVerticalSpace(constraints.maxHeight * 0.02),
                                                  const Text(
                                                    "Do you wish to change profile picture?",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: COLOR_BLACK,
                                                        fontSize: 20
                                                    ),
                                                  ),
                                                  addVerticalSpace(constraints.maxHeight * 0.02),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: FloatingActionButton(
                                                    backgroundColor: COLOR_DARKMINT,
                                                    onPressed: () async {

                                                      await pickImage();

                                                      var resp = await UserOp.upload_user_image(image!);
                                                      setState((){});
                                                      Navigator.pop(context);
                                                        if (resp != null){
                                                          final snackBar = SnackBar(backgroundColor: COLOR_MINT,
                                                              content: Row(
                                                                children: const [
                                                                  Icon(Icons.check_circle),
                                                                  SizedBox(width: 20),
                                                                  Expanded(child: Text('Profile picture successfully uploaded',
                                                                      style: TextStyle(color: COLOR_BLACK)))
                                                                ],
                                                              ));

                                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                        } else {
                                                          final snackBar = SnackBar(backgroundColor:  Colors.red.shade700,
                                                              content: Row(
                                                                children: const [
                                                                  Icon(Icons.cloud_off_rounded),
                                                                  SizedBox(width: 20),
                                                                  Expanded(child: Text('Failed to upload image!',
                                                                      style: TextStyle(color: COLOR_BLACK)))
                                                                ],
                                                              ));

                                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                        }

                                                      },
                                                    child: const Icon(Icons.photo_size_select_actual),
                                                  ),
                                                ),
                                                      SizedBox(
                                                        width: 50,
                                                        height: 50,
                                                        child: FloatingActionButton(
                                                          backgroundColor: COLOR_MINT,
                                                          onPressed: () async{

                                                            Navigator.pop(context);
                                                          },
                                                          child: const Icon(Icons.arrow_back),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                },
                                    child: const Icon(Icons.edit_outlined),
                                    style: ElevatedButton.styleFrom(
                                        primary: COLOR_DARKPURPLE,
                                        shape: StadiumBorder())
                                )
                              ]
                          )),
                      addVerticalSpace(constraints.maxHeight * 0.005),
                      Card(
                          child: ListTile(
                            title: Text("${user.first_name} ${user.last_name}"),
                            subtitle: Text("Name & Surname"),
                          )
                      ),
                      Card(
                          child: ListTile(
                            title: Text("${user.email} "),
                            subtitle: Text("E-mail"),
                          )
                      ),
                      Card(
                          child: ListTile(
                            title: Text("${user.age} "),
                            subtitle: Text("Age"),
                          )
                      ),
                      Card(
                          child: ListTile(
                            title: Text("${user.height} cm"),
                            subtitle: Text("Height"),
                          )
                      ),
                      Card(
                          child: ListTile(
                            title: Text("${genderItems[user.gender]} "),
                            subtitle: Text("Gender"),
                          )
                      ),
                      //Current weight pridat sackbar
                      Card(
                        child: ListTile(
                            onTap: () {
                              setState(() {
                                showDialog(

                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                          backgroundColor: COLOR_WHITE,
                                          content:
                                          SingleChildScrollView(
                                            physics: NeverScrollableScrollPhysics(),
                                            child:
                                            Container(
                                              width: constraints.maxWidth * 0.4,
                                              height: constraints.maxHeight * 0.28,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.all(5),
                                                      child: Form(
                                                          key: _formKey,
                                                          child: TextFormField(
                                                            controller: currweightController,
                                                            validator: (value) {
                                                              if (!RegExp(r'^[1-9]+[0-9]*([.]{1}[0-9]+|)$').hasMatch(value!) || value == '') {
                                                                return '        Please enter a valid weight';

                                                              }
                                                              else{
                                                                return null;
                                                              }
                                                            },
                                                            decoration: InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors.grey.shade200,
                                                              hintText: 'Current weight in kg',
                                                              focusedBorder: formBorder,
                                                              errorBorder: formBorder,
                                                              focusedErrorBorder: formBorder,
                                                              enabledBorder: formBorder,
                                                            ),
                                                          )
                                                      ),
                                                    ),
                                                    addVerticalSpace(constraints.maxHeight * 0.04),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child: FloatingActionButton(
                                                            backgroundColor: COLOR_DARKPURPLE,
                                                            onPressed: () async{
                                                              if (!_formKey.currentState!.validate()){
                                                                return;
                                                              }
                                                              var ret = await WeightOp.add_weight(double.parse(currweightController.text));
                                                              if(ret != null){


                                                                final snackBar = SnackBar(backgroundColor: COLOR_MINT,
                                                                    content: Row(
                                                                      children: const [
                                                                        Icon(Icons.check_circle),
                                                                        SizedBox(width: 20),
                                                                        Expanded(child: Text('Current weight successfully updated',
                                                                            style: TextStyle(color: COLOR_BLACK)))
                                                                      ],
                                                                    ));

                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                                              }
                                                              Navigator.pop(context);
                                                              setState(() {});

                                                            },
                                                            child: const Icon(Icons.check),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child: FloatingActionButton(
                                                            backgroundColor: COLOR_MINT,
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            child: const Icon(Icons.arrow_back),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                      );
                                    }
                                );
                              });
                            },
                            title: Text(currUserWeight!.weight.toString()),
                            subtitle: Text("Current weight"),
                            trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.edit),
                                ])
                        ),
                      ),
                      //Goal weight - done
                      Card(
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                showDialog(

                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                          backgroundColor: COLOR_WHITE,
                                          content:
                                          SingleChildScrollView(
                                            physics: NeverScrollableScrollPhysics(),
                                            child:
                                            Container(
                                              width: constraints.maxWidth * 0.4,
                                              height: constraints.maxHeight * 0.28,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.all(5),
                                                      child: Form(
                                                          key: _formKey,
                                                          child: TextFormField(
                                                            controller: goalweightController,
                                                            validator: (value) {
                                                              if (!RegExp(r'^[1-9]+[0-9]*([.]{1}[0-9]+|)$').hasMatch(value!) || value == '') {
                                                                return '        Please enter a valid weight';

                                                              }
                                                              else{
                                                                return null;
                                                              }
                                                            },
                                                            decoration: InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors.grey.shade200,
                                                              hintText: 'Goal weight in kg',
                                                              focusedBorder: formBorder,
                                                              errorBorder: formBorder,
                                                              focusedErrorBorder: formBorder,
                                                              enabledBorder: formBorder,
                                                            ),
                                                          )
                                                      ),
                                                    ),
                                                    addVerticalSpace(constraints.maxHeight * 0.04),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child: FloatingActionButton(
                                                            backgroundColor: COLOR_DARKPURPLE,
                                                            onPressed: () async{
                                                                if (!_formKey.currentState!.validate()){
                                                                  return;
                                                                } else {
                                                                  Map<String, dynamic> upUserData = {
                                                                    "goal_weight": double.parse(goalweightController.text)
                                                                  };
                                                                  var ret = await UserOp.update_user_data(upUserData);

                                                                  setState(() {
                                                                  });

                                                                  Navigator.pop(context);

                                                                  if(ret != null){

                                                                    final snackBar = SnackBar(backgroundColor: COLOR_MINT,
                                                                        content: Row(
                                                                          children: const [
                                                                            Icon(Icons.check_circle),
                                                                            SizedBox(width: 20),
                                                                            Expanded(child: Text('Goal weight successfully updated',
                                                                                style: TextStyle(color: COLOR_BLACK)))
                                                                          ],
                                                                        ));

                                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                                                  }
                                                                }

                                                            },
                                                            child: const Icon(Icons.check),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child: FloatingActionButton(
                                                            backgroundColor: COLOR_MINT,
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            child: const Icon(Icons.arrow_back),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                      );
                                    }
                                );
                              });
                            },
                            title: Text("${user.goal_weight} kg"),
                            subtitle: Text("Goal weight"),
                              trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.edit),
                                  ])
                          )

                      ),
                      // State
                      Card(
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                showDialog(

                                    context: context,
                                    builder: (context){
                                      return StatefulBuilder(builder: (context, setState) {
                                      return AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                          backgroundColor: COLOR_WHITE,
                                          content:
                                          SingleChildScrollView(
                                            physics: NeverScrollableScrollPhysics(),
                                            child:
                                            Container(
                                              width: constraints.maxWidth * 0.4,
                                              height: constraints.maxHeight * 0.28,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.all(5),
                                                      child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            const Text(
                                                              "State:",
                                                              textScaleFactor: 1.2,
                                                            ),
                                                            addHorizontalSpace(15),
                                                            DropdownButton<String>(
                                                              alignment: Alignment.center,
                                                              dropdownColor: Colors.grey.shade200,
                                                              value: stateChose,
                                                              style: const TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors.black
                                                              ),
                                                              items: stateItems.map((valueItem) {
                                                                return DropdownMenuItem<String>(
                                                                  value: valueItem,
                                                                  child: Text(valueItem),
                                                                );
                                                              }).toList(),
                                                              onChanged: (newValue) {
                                                                stateChose = newValue!;
                                                                setState(() {
                                                                  });
                                                              },
                                                            ),
                                                          ]
                                                      )
                                                    ),
                                                    addVerticalSpace(constraints.maxHeight * 0.04),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child: FloatingActionButton(
                                                            backgroundColor: COLOR_DARKPURPLE,
                                                            onPressed: () async {
                                                                Map<String, dynamic> upUserData = {
                                                                  "state": ((stateChose == stateItems[user.state]) ? null : stateItems.indexOf(stateChose))
                                                                };
                                                                var ret = await UserOp.update_user_data(upUserData);

                                                                setState(() {
                                                                });

                                                                Navigator.pop(context);

                                                                if(ret != null){
                                                                  final snackBar = SnackBar(backgroundColor: COLOR_MINT,
                                                                      content: Row(
                                                                        children: const [
                                                                          Icon(Icons.check_circle),
                                                                          SizedBox(width: 20),
                                                                          Expanded(child: Text('State successfully updated',
                                                                              style: TextStyle(color: COLOR_BLACK)))
                                                                        ],
                                                                      ));
                                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                }
                                                            },
                                                            child: const Icon(Icons.check),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child: FloatingActionButton(
                                                            backgroundColor: COLOR_MINT,
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            child: const Icon(Icons.arrow_back),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                      );
                                    });}
                                );
                              });
                            },
                            title: Text("${stateItems[user.state]} "),
                            subtitle: Text("State"),
                              trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.edit),
                                  ])
                          )

                      ),
                      // Nutr adviser
                      Card(
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                showDialog(

                                    context: context,
                                    builder: (context){
                                      return StatefulBuilder(builder: (context, setState) {
                                      return AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                          backgroundColor: COLOR_WHITE,
                                          content:
                                          SingleChildScrollView(
                                            physics: NeverScrollableScrollPhysics(),
                                            child:
                                            Container(
                                              width: constraints.maxWidth * 0.4,
                                              height: constraints.maxHeight * 0.28,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.all(5),
                                                      child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            const Text(
                                                              "Nutr. adviser:",
                                                              textScaleFactor: 1.2,
                                                            ),
                                                            addHorizontalSpace(15),
                                                            DropdownButton<String>(
                                                              alignment: Alignment.center,
                                                              dropdownColor: Colors.grey.shade200,
                                                              value: adviserChose,
                                                              style: const TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors.black
                                                              ),
                                                              items: adviserItems.map((valueItem) {
                                                                return DropdownMenuItem<String>(
                                                                  value: valueItem,
                                                                  child: Text(valueItem),
                                                                );
                                                              }).toList(),
                                                              onChanged: (newValue) {
                                                                setState(() {
                                                                  adviserChose = newValue!;
                                                                });
                                                              },
                                                            ),
                                                          ]
                                                      )
                                                    ),
                                                    addVerticalSpace(constraints.maxHeight * 0.04),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child: FloatingActionButton(
                                                            backgroundColor: COLOR_DARKPURPLE,
                                                            onPressed: () async {
                                                                  Map<String, dynamic> upUserData = {
                                                                    "is_nutr_adviser": ((adviserChose == adviserItems[user.is_nutr_adviser ? 0 : 1]) ? null : !user.is_nutr_adviser)
                                                                  };
                                                                  var ret = await UserOp.update_user_data(upUserData);

                                                                  setState(() {
                                                                  });

                                                                  Navigator.pop(context);

                                                                  if(ret != null){

                                                                    final snackBar = SnackBar(backgroundColor: COLOR_MINT,
                                                                        content: Row(
                                                                          children: const [
                                                                            Icon(Icons.check_circle),
                                                                            SizedBox(width: 20),
                                                                            Expanded(child: Text('Nutrition adviser status updated',
                                                                                style: TextStyle(color: COLOR_BLACK)))
                                                                          ],
                                                                        ));

                                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                  }

                                                            },
                                                            child: const Icon(Icons.check),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child: FloatingActionButton(
                                                            backgroundColor: COLOR_MINT,
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            child: const Icon(Icons.arrow_back),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                      ); });
                                    }
                                );
                              });
                            },
                            title: Text(user.is_nutr_adviser ? 'YES' : 'NO'),
                            subtitle: Text("Nutrition adviser"),
                              trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.edit),
                                  ])
                          ),
                      ),
                      // WebRTC address
                      Card(
                        child: ListTile(
                          onTap: () {
                              setState(() {
                                showDialog(

                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                        backgroundColor: COLOR_WHITE,
                                        content:
                                        SingleChildScrollView(
                                          physics: NeverScrollableScrollPhysics(),
                                          child:
                                        Container(
                                        width: constraints.maxWidth * 0.4,
                                          height: constraints.maxHeight * 0.28,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.all(5),
                                                  child: Form(
                                                      key: _formKey,
                                                      child: TextFormField(
                                                        controller: ipController,
                                                        validator: (value) {
                                                          if (validator.ip(value!) || value == '') {
                                                            return null;
                                                          }
                                                          else{
                                                            return '        Not a valid IP address format';
                                                          }
                                                        },
                                                        decoration: InputDecoration(
                                                          filled: true,
                                                          fillColor: Colors.grey.shade200,
                                                          hintText: webrtc_ip,
                                                          focusedBorder: formBorder,
                                                          errorBorder: formBorder,
                                                          focusedErrorBorder: formBorder,
                                                          enabledBorder: formBorder,
                                                        ),
                                                      )
                                                  ),
                                                ),
                                                addVerticalSpace(constraints.maxHeight * 0.04),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                      child: FloatingActionButton(
                                                        backgroundColor: COLOR_DARKPURPLE,
                                                        onPressed: () {

                                                          setState(() {
                                                            if (!_formKey.currentState!.validate()){
                                                              return;
                                                            } else {
                                                              if (ipController.text != '') {
                                                                webrtc_ip = ipController.text;
                                                                  final snackBar = SnackBar(backgroundColor: COLOR_MINT,
                                                                      content: Row(
                                                                        children: const [
                                                                          Icon(Icons.check_circle),
                                                                          SizedBox(width: 20),
                                                                          Expanded(child: Text('WebRTC Server adress updated',
                                                                              style: TextStyle(color: COLOR_BLACK)))
                                                                        ],
                                                                      ));

                                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              }
                                                              Navigator.pop(context);
                                                            }
                                                          });

                                                        },
                                                        child: const Icon(Icons.check),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                      child: FloatingActionButton(
                                                        backgroundColor: COLOR_MINT,
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Icon(Icons.arrow_back),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        )
                                      );
                                    }
                                );
                              });
                          },
                          title: Text(webrtc_ip),
                          subtitle: Text("WebRTC Server Address"),
                            trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.edit),
                                ])
                        ),
                      ),
                      /*addVerticalSpace(constraints.maxHeight * 0.05),
                      SizedBox(
                          height: 40, // <-- match-parent
                          width: 300,
                          child:  ElevatedButton(onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context){
                                  return StatefulBuilder(builder: (context, setState) {
                                  return AlertDialog(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                    backgroundColor: COLOR_WHITE,
                                    content: Container(
                                      width: constraints.maxWidth * 0.80,
                                      height: constraints.maxHeight * 0.6,
                                      child: Form(
                                      key: _formKey,child: Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            const Text(
                                              "Update account information",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: COLOR_BLACK,
                                                  fontSize: 20
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(10),
                                              child: TextFormField(
                                                controller: goalweightController,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return null;
                                                  }
                                                  else if ((!RegExp(r'^[1-9]+[0-9]*[.]{0,1}[0-9]+$').hasMatch(value)) || (double.parse(value) < 5)){
                                                    return 'Please enter a valid weight';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey.shade200,
                                                  icon: const Icon(
                                                    Icons.restaurant_menu,
                                                    color: COLOR_DARKPURPLE,
                                                  ),
                                                  hintText: 'Goal Weight',
                                                  focusedBorder: formBorder,
                                                  errorBorder: formBorder,
                                                  focusedErrorBorder: formBorder,
                                                  enabledBorder: formBorder,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(10),
                                              child: TextFormField(
                                                controller: heightController,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return null;
                                                  }
                                                  else if ((!RegExp(r'^[1-9]+[0-9]*[.]{0,1}[0-9]+$').hasMatch(value)) || (double.parse(value) < 40) || (double.parse(value) > 300)){
                                                    return 'Please enter a valid height';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey.shade200,
                                                  icon: const Icon(
                                                    Icons.accessibility_new_outlined,
                                                    color: COLOR_DARKPURPLE,
                                                  ),
                                                  hintText: 'Height in CM',
                                                  focusedBorder: formBorder,
                                                  errorBorder: formBorder,
                                                  focusedErrorBorder: formBorder,
                                                  enabledBorder: formBorder,
                                                ),
                                              ),
                                            ),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              const Text(
                                                "State:",
                                                textScaleFactor: 1.2,
                                              ),
                                              addHorizontalSpace(15),
                                              DropdownButton<String>(
                                                alignment: Alignment.center,
                                                dropdownColor: Colors.grey.shade200,
                                                value: stateChose,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black
                                                ),
                                                items: stateItems.map((valueItem) {
                                                  return DropdownMenuItem<String>(
                                                    value: valueItem,
                                                    child: Text(valueItem),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    stateChose = newValue!;
                                                  });
                                                },
                                              ),
                                            ]
                                        ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                const Text(
                                                  "Nutr. adviser:",
                                                  textScaleFactor: 1.2,
                                                ),
                                                addHorizontalSpace(15),
                                                DropdownButton<String>(
                                                  alignment: Alignment.center,
                                                  dropdownColor: Colors.grey.shade200,
                                                  value: adviserChose,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black
                                                  ),
                                                  items: adviserItems.map((valueItem) {
                                                    return DropdownMenuItem<String>(
                                                      value: valueItem,
                                                      child: Text(valueItem),
                                                    );
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    adviserChose = newValue!;
                                                    setState(() {
                                                    });

                                                  },
                                                ),
                                              ],
                                            ),
                                            addVerticalSpace(constraints.maxHeight * 0.04),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: FloatingActionButton(
                                                    backgroundColor: COLOR_DARKPURPLE,
                                                    onPressed: () async {
                                                      if (_formKey.currentState!.validate()){
                                                        Map<String, dynamic> upUserData = {
                                                          "goal_weight": ((goalweightController.text == '') ? null : double.parse(goalweightController.text)),
                                                          "height": ((heightController.text == '') ? null : double.parse(heightController.text)),
                                                          "state": ((stateChose == stateItems[user.state]) ? null : stateItems.indexOf(stateChose)),
                                                          "is_nutr_adviser": ((adviserChose == adviserItems[user.is_nutr_adviser ? 0 : 1]) ? null : !user.is_nutr_adviser)
                                                        };
                                                        var ret = await UserOp.update_user_data(upUserData);

                                                        setState(() {
                                                        });

                                                        Navigator.pop(context);

                                                        if(ret != null){

                                                              final snackBar = SnackBar(backgroundColor: COLOR_MINT,
                                                                  content: Row(
                                                              children: const [
                                                                Icon(Icons.check_circle),
                                                                SizedBox(width: 20),
                                                                Expanded(child: Text('Successfully updated',
                                                                style: TextStyle(color: COLOR_BLACK)))
                                                              ],
                                                              ));

                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                                      } else {
                                                          final snackBar = SnackBar(backgroundColor: COLOR_MINT,
                                                              content: Row(
                                                                children: const [
                                                                  Icon(Icons.check_circle),
                                                                  SizedBox(width: 20),
                                                                  Expanded(child: Text('Nothing changed',
                                                                      style: TextStyle(color: COLOR_BLACK)))
                                                                ],
                                                              ));

                                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                        }
                                                      }
                                                    },
                                                    child: const Icon(Icons.check),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: FloatingActionButton(
                                                    backgroundColor: COLOR_MINT,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Icon(Icons.arrow_back),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                    ),
                                  );});
                                }
                            );
                          },
                              child: const Text('Edit account',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                  primary: COLOR_DARKPURPLE,
                                  shape: StadiumBorder())
                          )
                      ),*/
                      addVerticalSpace(constraints.maxHeight * 0.015),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.red.shade700),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                  backgroundColor: COLOR_WHITE,
                                  content: Container(
                                    width: constraints.maxWidth * 0.4,
                                    height: constraints.maxHeight * 0.24,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          const Text(
                                            "Do you wish to delete your account?",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: COLOR_BLACK,
                                                fontSize: 20
                                            ),
                                          ),
                                          Text('!! This action is irreversible !!',
                                              style: TextStyle(color: Colors.red.shade700, fontSize: 18)),
                                          addVerticalSpace(constraints.maxHeight * 0.04),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: FloatingActionButton(
                                                  backgroundColor: Colors.red.shade700,
                                                  onPressed: () async {
                                                    try {
                                                      await UserOp.delete_user_account();
                                                      setState(() {
                                                      });
                                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                                      prefs.clear();
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    } catch (e) {
                                                      setState(() {
                                                      });
                                                      print(e);
                                                    }
                                                  },
                                                  child: const Icon(Icons.delete_forever_rounded),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: FloatingActionButton(
                                                  backgroundColor: COLOR_MINT,
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Icon(Icons.arrow_back),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                          );
                        },
                        child: const Text('Delete account',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                            fontWeight: FontWeight.bold)
                        ),
                      ),
                      addVerticalSpace(constraints.maxHeight * 0.015)
                    ])
            ),
          );
        }
        )
    );
  }
}
