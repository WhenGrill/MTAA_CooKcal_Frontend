

import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> mySnackBar(context, bg_color, text_color, text, icon){
  SnackBar snackBar = SnackBar (backgroundColor: bg_color,
      content: Row(
        children: [
          Icon(icon, color: text_color),
          SizedBox(width: 20),
          Expanded(child: Text(text,
              style: TextStyle(color: text_color)))
        ],
      ));
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}