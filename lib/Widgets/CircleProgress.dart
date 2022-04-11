import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cookcal/Utils/constants.dart';

class CircleProgress extends CustomPainter {
  final strikeCircle = 20.0;
  double currentProgress;

  CircleProgress(this.currentProgress);

  @override
  void paint(Canvas canvas, Size size){
    Paint circle = Paint()
        ..strokeWidth = strikeCircle
        ..color = Colors.black
        ..style = PaintingStyle.stroke;

    Offset center = Offset(size.width/2, size.height/2);
    double radius = 95;
    canvas.drawCircle(center, radius, circle);

  Paint animationArc = Paint()
  ..strokeWidth = strikeCircle
  ..color = COLOR_ORANGE
  ..style = PaintingStyle.stroke
  ..strokeCap = StrokeCap.round;

  double angle = 2 * pi * (currentProgress/100);
  canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
      pi/2, angle, false, animationArc);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate){

    return true;
  }
}