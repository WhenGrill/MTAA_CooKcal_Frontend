import 'package:cookcal/Utils/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cookcal/Widgets/CircleProgress.dart';
import 'package:cookcal/Utils/custom_functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation<double> _animation;
  double current_progress = 69;
  int max_kcal = 1600;
  int current_kcal = 1104;

  @override
  void initState(){
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(
            milliseconds: 800
        )
    );

    _animation = Tween<double>(begin: 0, end: current_progress).animate(_animationController)
    ..addListener(() {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints){
        return Container(
          color: COLOR_GREY,
          child: Column(
              children: [
               Align(
                 alignment: Alignment.bottomCenter,
                 child: ClipPath(
                   clipper: MyClipper(),
                   child:  Container(
                       color: COLOR_GREEN,
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
                                 color: COLOR_WHITE,
                               ),
                             ),
                           ),
                         ),
                       )
                   ),
                 ),
                 ),
                Container(
                  height: constraints.maxHeight * 0.58,
                  color: Colors.grey.shade200,
                  width: constraints.maxWidth,
                  child: Column(
                    children: [
                      Container(
                        height: constraints.maxHeight * 0.45,
                        color: Colors.grey.shade200,
                        width: constraints.maxWidth,
                        child: Column(
                          children: [
                            const Text(
                              'Your weight progress:',
                              style: TextStyle(fontSize: 30),
                            ),
                            Expanded(
                                child: LineChart(
                                    LineChartData(
                                        maxY: 100,
                                        maxX: 7,
                                        minY: 0,
                                        minX: 0,
                                        titlesData: FlTitlesData(
                                          bottomTitles: SideTitles(showTitles: false),
                                          leftTitles: SideTitles(showTitles: true),
                                          rightTitles: SideTitles(showTitles: true),
                                          topTitles: SideTitles(showTitles: false),
                                        ),
                                        lineBarsData: [
                                          LineChartBarData(
                                              spots: [
                                                const FlSpot(0, 0),
                                                const FlSpot(1, 55),
                                                const FlSpot(3, 65),
                                                const FlSpot(5, 57),
                                                const FlSpot(7, 63),
                                              ],
                                            isCurved: true,
                                            colors: [COLOR_GREEN, COLOR_ORANGE, COLOR_GREEN],
                                            barWidth: 5,
                                            belowBarData: BarAreaData(
                                              show: true,
                                              colors: gradientColors.map((e) => e.withOpacity(0.3)).toList(),
                                            )
                                          )
                                        ]
                                    )
                                )
                            )
                          ],
                        ),
                      ),
                      addVerticalSpace(constraints.maxHeight*0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            heroTag: 'btneat',
                            backgroundColor: COLOR_DARKGREEN,
                            onPressed: () {  },
                            child: const Icon(Icons.fastfood_outlined),
                          ),
                          FloatingActionButton(
                            heroTag: 'btnfood',
                            backgroundColor: COLOR_DARKGREEN,
                            onPressed: () {  },
                            child: Icon(Icons.add),
                          ),
                          FloatingActionButton(
                            heroTag: 'btnrecipes',
                            backgroundColor: COLOR_DARKGREEN,
                            onPressed: () {  },
                            child: Icon(Icons.list_alt),
                          )
                        ],
                      )
                    ],
                  )
                )
              ]
            )
        );
      }),
    );
  }
}