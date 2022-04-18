import 'package:cookcal/HTTP/login_register.dart';
import 'package:cookcal/Screens/Recipes/addRecipe_screen.dart';
import 'package:cookcal/Screens/Food/foodEatlist_screen.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:cookcal/model/weight.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cookcal/Widgets/CircleProgress.dart';
import 'package:cookcal/Utils/custom_functions.dart';
import 'package:cookcal/Screens/FoodList/foodlist_screen.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import '../Widgets/neomoprishm_box.dart';
import '../model/foodlist.dart';
class HomeScreen extends StatefulWidget {
  final UserOneOut user;
  final List<FoodListOut> foods;
  final List<FlSpot> weights;
  final double max_weight;
  final int curr_weight;
  const HomeScreen({Key? key, required this.foods, required this.weights, required this.curr_weight, required this.max_weight, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  late List<FoodListOut> foods = widget.foods;
  late List<FlSpot> weights = widget.weights;
  late UserOneOut user = widget.user;
  late int curr_weight = widget.curr_weight;

  late AnimationController _animationController;
  late Animation<double> _animation;
  // TODO this

  late double max_weight = widget.max_weight;
  int max_kcal = 0;
  int progress_max = 0;
  double current_kcal = 0;

  @override
  void initState(){
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(
            milliseconds: 800
        )
    );
    current_kcal = calculate_eaten(foods);
    max_kcal = calculate_max(curr_weight, user);

    if (current_kcal / max_kcal * 100 > 1000){
      double help = 0;
      help = current_kcal / 100;
      progress_max = help.toInt();
    }
    else {
      progress_max = max_kcal;
    }
    print(current_kcal);
    print(max_kcal);
    print(progress_max);
    _animation = Tween<double>(begin: 0, end: current_kcal / progress_max * 100).animate(_animationController)
    ..addListener(() {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();
    return Scaffold(
      backgroundColor: COLOR_WHITE,
      body: LayoutBuilder(builder: (context, constraints){
        return Container(
          color: COLOR_WHITE,
          child: Column(
              children: [
               Align(
                 alignment: Alignment.bottomCenter,
                 child: ClipPath(
                   clipper: OvalBottomBorderClipper(),
                   child:  Container(
                       color: COLOR_DARKPURPLE,
                       height: constraints.maxHeight * 0.40,
                       width: constraints.maxWidth,
                       child: CustomPaint(
                         foregroundPainter: CircleProgress(_animation.value),
                         child: Container(
                           width: constraints.maxWidth * 0.40,
                           height: constraints.maxHeight,
                           child: Center(
                             child: Text(
                               '${_animation.value.toInt()}%',
                               style: const TextStyle(
                                 fontSize: 50,
                                 color: COLOR_MINT,
                               ),
                             ),
                           ),
                         ),
                       )
                   ),
                 ),
                 ),
                Column(
                  children: [
                    addVerticalSpace(constraints.maxHeight * 0.02),
                    Container(
                        decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 4, 15),
                        child: Column(
                          children: [
                            const Text(
                              "You ate today",
                              style: TextStyle(
                                  color: COLOR_PURPLE,
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
                                    decoration: BoxDecoration(
                                        color: COLOR_DARKPURPLE,
                                        borderRadius: BorderRadius.circular(10)
                                    ),

                                    child: Center(
                                      child: Text(
                                          "${current_kcal.toInt()} / ${max_kcal}",
                                              maxLines: 1,
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
                                  color: COLOR_PURPLE,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                              ),
                            )
                          ],
                        )
                    ),
                    addVerticalSpace(constraints.maxHeight * 0.02),
                    Container(
                        decoration: neumorphism(COLOR_WHITE, Colors.grey[500]!, Colors.white, 4, 15),
                        child: Column(
                          children: [
                            const Text(
                              "Your weight journey",
                              style: TextStyle(
                                  color: COLOR_PURPLE,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Container(
                                  width: constraints.maxWidth * 0.85,
                                  height: constraints.maxHeight * 0.25,

                                  child: LineChart(
                                      LineChartData(
                                          backgroundColor: COLOR_DARKPURPLE,
                                          maxY: max_weight+20,
                                          maxX: weights.length.toDouble()-1,
                                          minY: null,
                                          minX: 0,
                                          titlesData: FlTitlesData(
                                            show: false,
                                          ),
                                          lineBarsData: [
                                            LineChartBarData(
                                                spots: weights,
                                                isCurved: true,
                                                colors: [COLOR_MINT, COLOR_PURPLE, COLOR_MINT, COLOR_PURPLE,COLOR_MINT],
                                                barWidth: 5,
                                                belowBarData: BarAreaData(
                                                  show: true,
                                                  colors: gradientColors.map((e) => e.withOpacity(0.3)).toList(),
                                                )
                                            )
                                          ]

                                      )
                                  )
                              ),
                            ),
                            const Text(
                              "Kg",
                              style: TextStyle(
                                  color: COLOR_PURPLE,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                              ),
                            )
                          ],
                        )
                    )
                  ],
                ),

              ]
            )
        );
      }),
    );
  }
}