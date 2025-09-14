import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
  // scaffoldBackgroundColor: Colors.black,
  textTheme: GoogleFonts.merriweatherTextTheme(ThemeData.dark().textTheme),
  brightness: Brightness.dark,
);