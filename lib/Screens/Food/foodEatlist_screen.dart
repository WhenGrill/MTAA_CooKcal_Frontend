import 'dart:convert';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:cookcal/Screens/Recipes/recipeProfile_screen.dart';
import 'package:cookcal/Status_code_handling/status_code_handling.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:cookcal/Widgets/myProgressbar.dart';
import 'package:cookcal/Widgets/mySnackBar.dart';
import 'package:flutter/material.dart';
import 'package:cookcal/Widgets/searchBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../HTTP/food_operations.dart';
import '../../HTTP/foodlist_operations.dart';
import '../../Utils/api_const.dart';
import '../../WebRTC/utils/AutoReconnectWebSocket.dart';
import '../../Widgets/neomoprishm_box.dart';
import '../../model/food.dart';
import '../../model/foodlist.dart';


class FoodEatListScreen extends StatefulWidget {
  const FoodEatListScreen({Key? key}) : super(key: key);

  @override
  _FoodEatListScreenState createState() => _FoodEatListScreenState();
}

class _FoodEatListScreenState extends State<FoodEatListScreen> {
  var ws = AutoReconnectWebSocket(Uri.parse(wbapiURL+ '/food/ws'), "Foods");
  final gramsControler = TextEditingController();
  final searchControler = TextEditingController();
  bool isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FoodListOperations foodListOperations = FoodListOperations();
  List<FoodOut> foods = [];
  late int curr_id = 0;



  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchControler.dispose();
    gramsControler.dispose();
    super.dispose();
  }

  @override
  initState(){
    super.initState();
    searchControler.addListener(searchControllerListener);
    ws.sink.add(searchControler.text);
  }

  void searchControllerListener() {
    print(searchControler.text);
    ws.sink.add(searchControler.text);
    ws.startReconnect();
  }

  load_data() async {
    var response = await FoodOperations().get_all_food(searchControler.text);
    if (response == null || response.statusCode != 200){
      return response;
    }

    List<FoodOut> foods_response = List<FoodOut>.from(
        response.data.map((x) => FoodOut.fromJson(x)));

    print(response.data);
    foods.clear();
    foods_response.forEach((element) {
      foods.add(element);
      print(element.id);
    });
    return response;
  }


  ws_load_data(var ws_foods) async {
    List<FoodOut> users_data = List<FoodOut>.from(ws_foods.map((x)=> FoodOut.fromJson(x)));
    foods.clear();
    users_data.forEach((element) {
      String name = element.title.toLowerCase();
      if (name.contains(searchControler.text.toLowerCase())){
        foods.add(element);
        print(element.id);
      }
    }
    );
    print(foods);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: COLOR_WHITE,
      body: LayoutBuilder(builder: (context, constraints){
        return Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: RoundedSearchInput(
                    hintText: 'Search here',
                    textController: searchControler,
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
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      var response = await load_data();
                      setState(() {
                        isLoading = false;
                      });
                      if(foodlist_show_handle(context, response)){
                        setState(() {});
                      }

                      searchControler.text = "";
                    },
                    child: const Text('Search Food'),
                  ),
                ),*/
                addVerticalSpace(constraints.maxHeight * 0.02),
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
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
                          if (snapshot.data != null){

                            var data = json.decode(snapshot.data);
                            if (searchControler.text == ""){
                              APICacheDBModel cacheDBModel = new APICacheDBModel(key: "Foods", syncData: json.encode(data));
                              APICacheManager().addCacheData(cacheDBModel);
                            }

                            ws_load_data(data['detail']);

                          }
                        return ListView.builder(
                      itemCount: foods.length,
                      itemBuilder: (context, index){
                        final food = foods[index];
                        return Padding(
                          padding: EdgeInsets.all(5),
                          child:  Container(
                              decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 4, 15),
                              child: ListTile(
                                tileColor: COLOR_WHITE,
                                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context){
                                        return AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                          backgroundColor: COLOR_WHITE,
                                          content: Container(
                                            width: 300,
                                            height: 210,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Adding:  ",
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          color: COLOR_BLACK,
                                                          fontSize: 17,
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          "${food.title}",
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(
                                                              color: COLOR_BLACK,
                                                              fontSize: 17,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  addVerticalSpace(15),
                                                  Form(
                                                    key: _formKey,
                                                    child: Container(
                                                        decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 2, 10),
                                                        margin: const EdgeInsets.all(10),
                                                        child: Center(
                                                          child: TextFormField(
                                                            maxLength: 10,
                                                            textAlign: TextAlign.center,
                                                            controller: gramsControler,
                                                            validator: (value) {
                                                              if (value == null || value.isEmpty) {
                                                                return '                 Enter a food measurement';
                                                              }
                                                              else if (!RegExp(r'^[1-9]+[0-9]*([.]{1}[0-9]+|)$').hasMatch(value)){
                                                                return '               Please enter a valid number';
                                                              }
                                                              return null;
                                                            },
                                                            decoration: const InputDecoration(
                                                                counterText: "",
                                                                hintText: 'Amount in grams',
                                                                enabledBorder: InputBorder.none,
                                                                focusedBorder: InputBorder.none,
                                                                border: InputBorder.none
                                                            ),
                                                          ),
                                                        )
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
                                                          backgroundColor: COLOR_DARKPURPLE,
                                                          onPressed: () async{
                                                            if (!_formKey.currentState!.validate()){
                                                              return;
                                                            }
                                                            FoodlistIn data = FoodlistIn(
                                                              id_food: food.id,
                                                              amount: double.parse(gramsControler.text),
                                                            );
                                                            var response = await foodListOperations.AddFood(data);
                                                            if (add_food_handle(context, response)){
                                                              mySnackBar(context, COLOR_DARKMINT, COLOR_WHITE, 'Food added successfully', Icons.check_circle);
                                                            }
                                                            gramsControler.text = "";
                                                            Navigator.pop(context);
                                                          },
                                                          child: const Icon(Icons.add),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 50,
                                                        height: 50,
                                                        child: FloatingActionButton(
                                                          backgroundColor: COLOR_MINT,
                                                          onPressed: () {
                                                            gramsControler.text = "";
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
                                leading: CircleAvatar(
                                  backgroundColor: COLOR_WHITE,
                                  backgroundImage: AssetImage(food_icons[random(0,4)]), // no matter how big it is, it won't overflow
                                ),
                                title: Text(food.title),
                                subtitle: Text("${food.kcal_100g} Kcal / 100g"),

                              )
                          ),
                        );
                      },
                    );
                        }
                    )
                )
              ],
            ),
            myProgressBar(isLoading)
          ],
        );
        }
      ),
    );
  }
}
