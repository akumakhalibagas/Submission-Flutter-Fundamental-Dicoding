import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color colorPrimary = Color(0xFFFA9700);
const Color colorSecondary = Color(0xFF8919FA);

const colorBlack = Color(0xFF000000);
const colorWhite = Color(0xFFF1F2F6);
const colorWhiteTransparent50 = Color(0x80F1F2F6);
const colorTransparent = Color(0x00F1F2F6);

final TextTheme myTextTheme = TextTheme(
  headline4: GoogleFonts.montserrat(
    fontSize: 32,
    fontWeight: FontWeight.w700,
  ),
  headline5: GoogleFonts.montserrat(
    fontSize: 23,
    fontWeight: FontWeight.w700,
  ),
  headline6: GoogleFonts.montserrat(
    fontSize: 19,
    fontWeight: FontWeight.w500,
  ),
  bodyText1: GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
  bodyText2: GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  button: GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
);
