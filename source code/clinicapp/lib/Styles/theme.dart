import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey));
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white));
}

TextStyle get textStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    fontSize: 18,
  ));
}
