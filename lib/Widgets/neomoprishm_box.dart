
import 'package:cookcal/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cookcal/Utils/constants.dart';

/*class NeumorphismDesignButton extends StatefulWidget {
  final bool isElevated;

  const NeumorphismDesignButton({Key? key, required this.isElevated})
      : super(key: key);

  _NeomorphismDesingState createState() => _NeomorphismDesingState();
}

class _NeomorphismDesingState extends State<NeumorphismDesignButton> {
  late bool isElevated =widget.isElevated;
  @override
  Widget build(BuildContext context){
    return AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          color: COLOR_WHITE,
        borderRadius: BorderRadius.circular(50),
    boxShadow:
        isElevated ?
    [
    BoxShadow(
    color: Colors.grey[500]!,
    offset: const Offset(4,4),
    blurRadius: 15,
    spreadRadius: 1,
    ),
    const BoxShadow(
    color: Colors.white,
    offset: Offset(-4, -4),
    )
    ]
            : null

      )
    );
  }
}
*/
BoxDecoration neumorphism(Color main_color, Color shadow, Color sub,double offset, double circular){
  return
    BoxDecoration(
      color: main_color,
      borderRadius: BorderRadius.circular(circular),
  boxShadow:
    [
    BoxShadow(
      color: shadow,
      offset: Offset(offset,offset),
      blurRadius: 15,
      spreadRadius: 1,
    ),
    BoxShadow(
      color: sub,
      offset: Offset(-offset, -offset),
    )
  ]);
}