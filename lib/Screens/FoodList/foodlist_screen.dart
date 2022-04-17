import 'package:cookcal/HTTP/foodlist_operations.dart';
import 'package:cookcal/HTTP/login_register.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/model/foodlist.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cookcal/Widgets/CircleProgress.dart';
import 'package:cookcal/Utils/custom_functions.dart';

import '../../Widgets/neomoprishm_box.dart';

class FoodListScreen extends StatefulWidget {
  final List<FoodListOut> foods;
  final int curr_weight;
  final UserOneOut user;
  const FoodListScreen({Key? key, required this.foods, required this.curr_weight, required this.user}) : super(key: key);

  @override
  _FoodListScreenState createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> with SingleTickerProviderStateMixin {

  late List<FoodListOut> foods = widget.foods;
  late int curr_weight = widget.curr_weight;
  late UserOneOut user = widget.user;
  FoodListOperations foodListOperations = FoodListOperations();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_WHITE,
      body: LayoutBuilder(builder: (context, constraints){
        return Container(
            color: COLOR_WHITE,
          child: Column(
            children: [
              Card(
                  shadowColor: COLOR_PURPLE,
                  color: COLOR_VERYDARKPURPLE,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 20,
                  child: Column(
                    children: [
                      const Text(
                        "You ate today",
                        style: TextStyle(
                            color: COLOR_MINT,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Container(
                          width: constraints.maxWidth * 0.85,
                          height: constraints.maxHeight * 0.1,
                          child: Container(
                              color: COLOR_DARKPURPLE,
                              child: Center(
                                child: Text(
                                  "${calculate_eaten(foods).toInt()} / ${calculate_max(curr_weight, user)}",
                                  style: TextStyle(color: COLOR_MINT,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              )
                          ),

                        ),
                      ),
                      const Text(
                        "Kcal",
                        style: TextStyle(
                            color: COLOR_MINT,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),
                      )
                    ],
                  )
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: foods.length,
                  itemBuilder: (context, index){
                    final food = foods[index];
                    return Padding(
                        padding: EdgeInsets.all(5),
                      child: Container(
                          decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 4, 15),
                          child: ListTile(
                            tileColor: COLOR_WHITE,
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                      backgroundColor: COLOR_WHITE,
                                      content: Container(
                                        width: constraints.maxWidth * 0.3,
                                        height: constraints.maxHeight * 0.2,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Column(
                                            children: [
                                              Text(
                                                "Do you wish to delete ${food.title}?",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: COLOR_BLACK,
                                                    fontSize: 17
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
                                                      onPressed: () async {
                                                        await foodListOperations.delete_food(food.id);

                                                        foods.removeWhere((element) => foods.indexOf(element) == index);
                                                        setState(() {

                                                        });
                                                        Navigator.pop(context);
                                                        final snackBar = SnackBar(backgroundColor: COLOR_DARKMINT,
                                                            content: Row(
                                                              children: const [
                                                                Icon(Icons.check_circle, color: COLOR_WHITE),
                                                                SizedBox(width: 20),
                                                                Expanded(child: Text('Food removed',
                                                                    style: TextStyle(color: COLOR_WHITE)))
                                                              ],
                                                            ));
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                                    );
                                  }
                              );
                            },
                            leading: CircleAvatar(
                              backgroundColor: COLOR_WHITE,
                              backgroundImage: AssetImage(food_icons[random(0,4)]), // no matter how big it is, it won't overflow
                            ),
                            title: Text(food.title),
                            subtitle: Text("${food.amount}g => ${food.amount * food.kcal_100g / 100} Kcal"),

                          )
                      ),
                    );
                  },
                ),
              )
            ],
          )
        );
      }),
    );
  }
}