import 'package:cookcal/Utils/constants.dart';
import 'package:flutter/material.dart';

Widget myProgressBar(bool isLoading){
  return isLoading ? Container(
      child: LinearProgressIndicator(
        color: COLOR_MINT,
        backgroundColor: COLOR_PURPLE,
      )
  ) : SizedBox.shrink();
}

Widget myProgressCircle(bool isLoading){
  return isLoading ? Container(
      child: CircularProgressIndicator(
        color: COLOR_MINT,
        backgroundColor: COLOR_PURPLE,
      )
  ) : SizedBox.shrink();
}