import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const COLOR_BLACK = Colors.black;
const COLOR_ORANGE = Color(0xffffd269);
const COLOR_CREAME = Color(0xffF0BB62);
const COLOR_WHITE = Color(0xffeeeeff);
const COLOR_GREEN = Color(0xff244026);
const COLOR_DARKGREEN = Color(0xff003004);
const COLOR_GREY = Color(0xffeeeeee);

const gradientColors = [
  COLOR_GREEN, COLOR_ORANGE, COLOR_GREEN,
];

TextTheme defaultText = TextTheme(
    headline1: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 96),
    headline2: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 60),
    headline3: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 48),
    headline4: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 34),
    headline5: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 24),
    headline6: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 20),
    bodyText1: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.normal),
    bodyText2: GoogleFonts.nunito(
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    subtitle1: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.normal),
    subtitle2: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w400),
    button: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w400),
    caption: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.normal));