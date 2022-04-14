import 'package:cookcal/Utils/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cookcal/Widgets/CircleProgress.dart';
import 'package:cookcal/Utils/custom_functions.dart';

class FoodListScreen extends StatefulWidget {
  const FoodListScreen({Key? key}) : super(key: key);

  @override
  _FoodListScreenState createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints){
        return Container(
            color: COLOR_GREY,
          child: Column(
            children: [
              const Text(
                "Today's summary:",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                "${calculate_eaten(food_list).toStringAsFixed(2)}/${calculate_howmucheat(userIdExample).toStringAsFixed(2)}",
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
                  itemCount: food_list.length,
                  itemBuilder: (context, index){
                    final food = food_list[index];
                    return Card(
                        child: ListTile(
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
                                      height: constraints.maxHeight * 0.20,
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
                                                    backgroundColor: COLOR_DARKPURPLE,
                                                    onPressed: () {
                                                      food_list.removeWhere((element) => food_list.indexOf(element) == index);
                                                      setState(() {

                                                      });
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