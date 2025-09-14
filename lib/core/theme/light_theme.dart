import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData.light(useMaterial3: true).copyWith(
  scaffoldBackgroundColor: Colors.white,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
  brightness: Brightness.light,
);