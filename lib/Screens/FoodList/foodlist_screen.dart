import 'package:cookcal/HTTP/foodlist_operations.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/model/foodlist.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cookcal/Widgets/CircleProgress.dart';
import 'package:cookcal/Utils/custom_functions.dart';

class FoodListScreen extends StatefulWidget {
  final List<FoodListOut> foods;
  const FoodListScreen({Key? key, required this.foods}) : super(key: key);

  @override
  _FoodListScreenState createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> with SingleTickerProviderStateMixin {

  late List<FoodListOut> foods = widget.foods;
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
              const Text(
                "Today's summary:",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                "${calculate_eaten(foods).toStringAsFixed(2)}/${calculate_howmucheat(userIdExample).toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
              const Divider(
                color: COLOR_DARKPURPLE,
                thickness: 2,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: foods.length,
                  itemBuilder: (context, index){
                    final food = foods[index];
                    return Card(
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