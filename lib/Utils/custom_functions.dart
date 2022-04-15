import 'package:flutter/material.dart';
import 'package:cookcal/Utils/constants.dart';
import 'package:flutter/services.dart';
import 'dart:math';


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

double calculate_eaten(List<FoodList> foodList){
  double sum = 0;
  for (FoodList food in foodList){
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