import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:cookcal/HTTP/users_operations.dart';
import 'package:cookcal/HTTP/weight_operations.dart';
import 'package:cookcal/Utils/api_const.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:cookcal/Widgets/myProgressbar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

import '../../HTTP/login_register.dart';
import '../../Status_code_handling/status_code_handling.dart';
import '../../Widgets/mySnackBar.dart';
import '../../Widgets/neomoprishm_box.dart';
import '../../model/users.dart';
import '../../model/weight.dart';



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

  bool isLoading = false;

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
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                child:
                Container(
                    color: COLOR_WHITE,
                    child: Column(
                        children: [
                          addVerticalSpace(constraints.maxHeight * 0.02),
                          Container(
                              width: constraints.maxWidth,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 2,10),
                              child: Center(
                                child: Text(
                                    'Your Profile',
                                    style: TextStyle(fontSize: 33, color: COLOR_PURPLE, fontWeight: FontWeight.bold)
                                ),
                              )
                          ),
                          addVerticalSpace(constraints.maxHeight * 0.01),
                          addVerticalSpace(constraints.maxHeight * 0.01),
                          Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 50),
                                    Container(
                                      width: 105.0,
                                      height: 105.0,
                                      decoration: const BoxDecoration(),
                                      child:

                                      Container(
                                          width: 600,
                                          height: 600,
                                          color: COLOR_WHITE,
                                          child:
                                          CircleAvatar(backgroundImage:
                                          image != null ? FileImage(image!) : (uImage != null ? uImage! : AssetImage(user_icons[user.gender]))//FileImage(File(user_icons[user.gender])) as ImageProvider))
                                            , backgroundColor: Colors.transparent,)),

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
                                                height: constraints.maxHeight * 0.42,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          Container(
                                                              height: 100,
                                                              width: 100,
                                                              child:
                                                              CircleAvatar(backgroundImage:
                                                              image != null ? FileImage(image!) : (uImage != null ? uImage! : AssetImage(user_icons[user.gender]))//FileImage(File(user_icons[user.gender])) as ImageProvider))
                                                                , backgroundColor: Colors.transparent,))
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
                                                                setState(() {
                                                                  isLoading = true;
                                                                });
                                                                await pickImage();
                                                                var s_resp = null;

                                                                if (image != null){
                                                                  StreamedResponse? s_resp = await UserOp.upload_user_image(image!);
                                                                  await image_handle(context, s_resp, this);
                                                                  Navigator.pop(context);
                                                                }
                                                                setState(() {
                                                                  isLoading = false;
                                                                });
                                                                //Response? r_resp;
                                                                setState((){});
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
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            width: constraints.maxWidth,
                            height: constraints.maxHeight *0.01,
                            decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 2,10),
                          ),
                          Card(
                              color: COLOR_WHITE,
                              child: ListTile(
                                title: Text("${user.first_name} ${user.last_name}"),
                                subtitle: Text("Name & Surname"),
                              )
                          ),
                          Card(
                              color: COLOR_WHITE,
                              child: ListTile(
                                title: Text("${user.email} "),
                                subtitle: Text("E-mail"),
                              )
                          ),
                          Card(
                              color: COLOR_WHITE,
                              child: ListTile(
                                title: Text("${user.age} "),
                                subtitle: Text("Age"),
                              )
                          ),
                          Card(
                              color: COLOR_WHITE,
                              child: ListTile(
                                title: Text("${user.height} cm"),
                                subtitle: Text("Height"),
                              )
                          ),
                          Card(
                              color: COLOR_WHITE,
                              child: ListTile(
                                title: Text("${genderItems[user.gender]} "),
                                subtitle: Text("Gender"),
                              )
                          ),

                          Card(
                            color: COLOR_WHITE,
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
                                                  width: constraints.maxWidth * 0.9,
                                                  height: constraints.maxHeight * 0.35,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.all(5),
                                                          child: Form(
                                                              key: _formKey,
                                                              child: Container(
                                                                padding: EdgeInsets.all(10),
                                                                margin: EdgeInsets.all(10),
                                                                decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 2,10),
                                                                child: TextFormField(
                                                                  maxLength: 10,
                                                                  controller: currweightController,
                                                                  validator: (value) {
                                                                    if (!RegExp(r'^[1-9]+[0-9]*([.]{1}[0-9]+|)$').hasMatch(value!) || value == '' || double.parse(value) > 800 || double.parse(value) < 30) {
                                                                      return 'Please enter a valid weight';

                                                                    }
                                                                    else{
                                                                      return null;
                                                                    }
                                                                  },
                                                                  decoration: const InputDecoration(
                                                                      icon: Icon(
                                                                        Icons.scale,
                                                                        color: COLOR_PURPLE,
                                                                      ),
                                                                      errorMaxLines: 2,
                                                                      counterText: "",
                                                                      hintText: 'Current Weight in Kg',
                                                                      enabledBorder: InputBorder.none,
                                                                      focusedBorder: InputBorder.none,
                                                                      border: InputBorder.none
                                                                  ),
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
                                                                  //TODO odstríniť printy kde je response
                                                                  setState(() {
                                                                    isLoading = true;
                                                                  });
                                                                  var response = await WeightOp.add_weight(double.parse(currweightController.text));
                                                                  setState(() {
                                                                    isLoading = false;
                                                                  });
                                                                  bool boolean = await add_weightmeasurement_handle(context, response);
                                                                  if(boolean){
                                                                    mySnackBar(context, COLOR_DARKMINT, COLOR_WHITE, "Weight updated, please refresh this screen", Icons.check_circle);
                                                                    setState(() {});
                                                                  }
                                                                  var UserWeightCache = await APICacheManager().getCacheData("User${uId}_Weight");
                                                                  List<dynamic> data = json.decode(UserWeightCache.syncData);
                                                                  data.add({
                                                                    'weight': double.parse(currweightController.text),
                                                                    'measure_time': DateTime.now().toString(),
                                                                  });
                                                                  APICacheDBModel cacheDBModel = new APICacheDBModel(key: "User${uId}_Weight", syncData: json.encode(data));
                                                                  await APICacheManager().addCacheData(cacheDBModel);

                                                                  Navigator.pop(context);

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
                                title: Text(currUserWeight!.weight.toString() + " kg"),
                                subtitle: Text("Current weight"),
                                trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.edit),
                                    ])
                            ),
                          ),

                          Card(
                              color: COLOR_WHITE,
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
                                                    width: constraints.maxWidth * 0.9,
                                                    height: constraints.maxHeight * 0.35,
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets.all(5),
                                                            child: Form(
                                                                key: _formKey,
                                                                child: Container(
                                                                  padding: EdgeInsets.all(10),
                                                                  margin: EdgeInsets.all(10),
                                                                  decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 2,10),
                                                                  child: TextFormField(
                                                                    maxLength: 10,
                                                                    controller: goalweightController,
                                                                    validator: (value) {
                                                                      if (!RegExp(r'^[1-9]+[0-9]*([.]{1}[0-9]+|)$').hasMatch(value!) || value == '' || double.parse(value) > 800 || double.parse(value) < 30) {
                                                                        return 'Please enter a valid weight';

                                                                      }
                                                                      else{
                                                                        return null;
                                                                      }
                                                                    },
                                                                    decoration: const InputDecoration(
                                                                        icon: Icon(
                                                                          Icons.scale_outlined,
                                                                          color: COLOR_PURPLE,
                                                                        ),
                                                                        counterText: "",
                                                                        errorMaxLines: 2,
                                                                        hintText: 'Goal weight in Kg',
                                                                        enabledBorder: InputBorder.none,
                                                                        focusedBorder: InputBorder.none,
                                                                        border: InputBorder.none
                                                                    ),
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
                                                                      setState(() {
                                                                        isLoading = true;
                                                                      });
                                                                      var response = await UserOp.update_user_data(upUserData);
                                                                      setState(() {
                                                                        isLoading = false;
                                                                      });
                                                                      bool boolean = await update_user_handle(context, response);
                                                                      if(boolean){
                                                                        mySnackBar(context, COLOR_DARKMINT, COLOR_WHITE, "Goal weight updated, please refresh this screen", Icons.check_circle);
                                                                        var UserCache = await APICacheManager().getCacheData("User${uId}");
                                                                        Map<String, dynamic> data = json.decode(UserCache.syncData);
                                                                        data["goal_weight"] = double.parse(goalweightController.text);
                                                                        APICacheDBModel cacheDBModel = new APICacheDBModel(key: "User${uId}", syncData: json.encode(data));
                                                                        await APICacheManager().addCacheData(cacheDBModel);
                                                                        setState(() {});

                                                                      } else if (response == null) {
                                                                        var UserCache = await APICacheManager().getCacheData("User${uId}");
                                                                        Map<String, dynamic> data = json.decode(UserCache.syncData);
                                                                        data["goal_weight"] = double.parse(goalweightController.text);
                                                                        APICacheDBModel cacheDBModel = new APICacheDBModel(key: "User${uId}", syncData: json.encode(data));
                                                                        await APICacheManager().addCacheData(cacheDBModel);
                                                                      }

                                                                      Navigator.pop(context);
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
                              color: COLOR_WHITE,
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
                                                                        dropdownColor: COLOR_WHITE,
                                                                        focusColor: COLOR_WHITE,
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
                                                                        "state": ((stateChose == stateItems[user.state]) ? (stateChose == stateItems[user.state]) : stateItems.indexOf(stateChose))
                                                                      };

                                                                      var response = await UserOp.update_user_data(upUserData);
                                                                      bool boolean = await update_user_handle(context, response);
                                                                      if (boolean){
                                                                        mySnackBar(context, COLOR_DARKMINT, COLOR_WHITE, "State updated, please refresh this screen", Icons.check_circle);
                                                                        var UserCache = await APICacheManager().getCacheData("User${uId}");
                                                                        Map<String, dynamic> data = json.decode(UserCache.syncData);
                                                                        data["state"] = ((stateChose == stateItems[user.state]) ? (stateChose == stateItems[user.state]) : stateItems.indexOf(stateChose));
                                                                        APICacheDBModel cacheDBModel = new APICacheDBModel(key: "User${uId}", syncData: json.encode(data));
                                                                        await APICacheManager().addCacheData(cacheDBModel);
                                                                        setState(() {});
                                                                      } else if (response == null) {
                                                                        var UserCache = await APICacheManager().getCacheData("User${uId}");
                                                                        Map<String, dynamic> data = json.decode(UserCache.syncData);
                                                                        data["state"] = ((stateChose == stateItems[user.state]) ? (stateChose == stateItems[user.state]) : stateItems.indexOf(stateChose));
                                                                        APICacheDBModel cacheDBModel = new APICacheDBModel(key: "User${uId}", syncData: json.encode(data));
                                                                        await APICacheManager().addCacheData(cacheDBModel);
                                                                      }

                                                                      Navigator.pop(context);
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
                            color: COLOR_WHITE,
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
                                                                      dropdownColor: COLOR_WHITE,
                                                                      focusColor: COLOR_WHITE,
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
                                                                      "is_nutr_adviser": ((adviserChose == adviserItems[user.is_nutr_adviser ? 0 : 1]) ? (adviserChose == adviserItems[user.is_nutr_adviser ? 0 : 1]) : !user.is_nutr_adviser)
                                                                    };

                                                                    var response = await UserOp.update_user_data(upUserData);
                                                                    bool boolean = await update_user_handle(context, response);
                                                                    if(boolean){
                                                                      mySnackBar(context, COLOR_DARKMINT, COLOR_WHITE, "Updated successfully, please refresh this screen", Icons.check_circle);
                                                                      setState(() {});
                                                                      var UserCache = await APICacheManager().getCacheData("User${uId}");
                                                                      Map<String, dynamic> data = json.decode(UserCache.syncData);
                                                                      data["is_nutr_adviser"] = ((adviserChose == adviserItems[user.is_nutr_adviser ? 0 : 1]) ? (adviserChose == adviserItems[user.is_nutr_adviser ? 0 : 1]) : !user.is_nutr_adviser);
                                                                      APICacheDBModel cacheDBModel = new APICacheDBModel(key: "User${uId}", syncData: json.encode(data));
                                                                      await APICacheManager().addCacheData(cacheDBModel);

                                                                    } else if (response == null) {
                                                                      var UserCache = await APICacheManager().getCacheData("User${uId}");
                                                                      Map<String, dynamic> data = json.decode(UserCache.syncData);
                                                                      data["is_nutr_adviser"] = ((adviserChose == adviserItems[user.is_nutr_adviser ? 0 : 1]) ? (adviserChose == adviserItems[user.is_nutr_adviser ? 0 : 1]) : !user.is_nutr_adviser);
                                                                      APICacheDBModel cacheDBModel = new APICacheDBModel(key: "User${uId}", syncData: json.encode(data));
                                                                      await APICacheManager().addCacheData(cacheDBModel);
                                                                    }

                                                                    Navigator.pop(context);


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
                            color: COLOR_WHITE,
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
                                                  width: constraints.maxWidth * 0.9,
                                                  height: constraints.maxHeight * 0.35,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                            margin: EdgeInsets.all(5),
                                                            child: Container(
                                                              padding: EdgeInsets.all(10),
                                                              margin: EdgeInsets.all(10),
                                                              decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 2,10),
                                                              child: Form(
                                                                  key: _formKey,
                                                                  child: TextFormField(
                                                                    controller: ipController,
                                                                    validator: (value) {
                                                                      if (validator.ip(value!) || value == '') {
                                                                        return null;
                                                                      }
                                                                      else{
                                                                        return 'Not a valid IP address format';
                                                                      }
                                                                    },
                                                                    decoration: InputDecoration(
                                                                        icon: const Icon(
                                                                          Icons.wifi,
                                                                          color: COLOR_PURPLE,
                                                                        ),
                                                                        hintText: webrtc_ip,
                                                                        errorMaxLines: 2,
                                                                        enabledBorder: InputBorder.none,
                                                                        focusedBorder: InputBorder.none,
                                                                        border: InputBorder.none
                                                                    ),
                                                                  )
                                                              ),
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
                                        height: constraints.maxHeight * 0.3,
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
                                                          //TODO
                                                          setState(() {
                                                            isLoading = true;
                                                          });
                                                          await UserOp.delete_user_account();
                                                          setState(() {
                                                          });
                                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                                          setState(() {
                                                            isLoading = false;
                                                          });
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
              ),
              myProgressBar(isLoading)
            ],
          );
        }
        )
    );
  }
}
