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
      appBar: AppBar(
        title: Text('CooKcal'),
    centerTitle: true,
    backgroundColor: COLOR_GREEN,
    actions: [
    IconButton(onPressed: (){

    }, icon: Icon(Icons.settings))
    ],
    ),
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
                color: COLOR_GREEN,
                thickness: 2,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: food_list.length,
                  itemBuilder: (context, index){
                    final food = food_list[index];
                    return Card(
                        child: ListTile(
                          onTap: () {},
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