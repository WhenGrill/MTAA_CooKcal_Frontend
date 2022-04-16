import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cookcal/Utils/constants.dart';

class CircleProgress extends CustomPainter {
  final strikeCircle = 20.0;
  final strikeCircle_mid = 15.0;
  final strikeCircle_small = 10.0;
  final strikeCircle_smallest = 4.0;
  double currentProgress;

  CircleProgress(this.currentProgress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint circle1 = Paint()
      ..strokeWidth = strikeCircle
      ..color = Color(0xff15001f)
      ..style = PaintingStyle.stroke;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = 95;
    canvas.drawCircle(center, radius, circle1);

    Paint circle2 = Paint()
      ..strokeWidth = strikeCircle_mid
      ..color = Color(0xff13001c)
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, circle2);

    Paint circle3 = Paint()
      ..strokeWidth = strikeCircle_small
      ..color = Color(0xff0e0014)
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, circle3);

    Paint circle4 = Paint()
      ..strokeWidth = strikeCircle_smallest
      ..color = COLOR_BLACK
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, circle4);

    Paint animationArc = Paint()
      ..strokeWidth = strikeCircle
      ..color = COLOR_VERYDARKMINT
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double angle = 2 * pi * (currentProgress / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        pi / 2, angle, false, animationArc);


    Paint animationArc2 = Paint()
      ..strokeWidth = strikeCircle_mid
      ..color = COLOR_DARKMINT
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        pi / 2, angle, false, animationArc2);

    Paint animationArc3 = Paint()
      ..strokeWidth = strikeCircle_small
      ..color = COLOR_MINT
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        pi / 2, angle, false, animationArc3);

    Paint animationArc4 = Paint()
      ..strokeWidth = strikeCircle_smallest
      ..color = COLOR_WHITE
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        pi / 2, angle, false, animationArc4);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate){

    return true;
  }
}