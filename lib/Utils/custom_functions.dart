import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:flutter/services.dart';
import 'dart:math';

import '../model/foodlist.dart';
import '../model/weight.dart';


Widget addVerticalSpace(double height){
  return SizedBox(
      height:height
  );
}

Widget addHorizontalSpace(double width){
  return SizedBox(
      width:width
  );
}

int random(min, max) {
  return min + Random().nextInt(max - min);
}

double calculate_eaten(List<FoodListOut> foodList){
  double sum = 0;
  for (FoodListOut food in foodList){
    sum = sum + food.amount * food.kcal_100g / 100;
  }

  return sum;
}

double calculate_howmucheat(UserIdExample user){
  int weight = 69;
  double toEat = 0;
  if (user.gender == 1) {
    toEat = 9.99 * weight + 6.25 * user.height - 4.92 * user.age + 5;
  } else {
    toEat = 9.99 * weight + 6.25 * user.height - 4.92 * user.age - 161;
  }

  return toEat;
}

List<FlSpot> make_plot(List<WeightOut> weights){
  List<FlSpot> spots = [FlSpot(0, 0)];
  double y = 0;
  double x = 1;
  for (WeightOut weight in weights){
    spots.add(FlSpot(
      x,weight.weight
    ));
    y++;
    x++;
  }

  return spots;
}

double get_max_weight(List<WeightOut> weights){
  double max = 0;
  for (WeightOut weight in weights){
    if (max < weight.weight){
      max = weight.weight;
    }
  }
  return max;
}

Widget assert_to_image(BuildContext context, String path) {

  return Image(image: AssetImage(path));
}
/*Future scanBarcode() async {
  String barcode;

  try {
    barcode = await FlutterBarcodeScanner.scanBarcode(
        "#ff666",
        "Cancel",
        true,
        ScanMode.BARCODE);
  } on PlatformException {
    barcode = "failed to scan";
  }

  print(barcode);
}*/