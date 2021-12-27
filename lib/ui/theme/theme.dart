import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    textTheme: GoogleFonts.montserratTextTheme(),
  );
  static final dark = ThemeData.dark().copyWith(
    textTheme: GoogleFonts.montserratTextTheme(
      ThemeData.dark().textTheme
    ),
  );
}