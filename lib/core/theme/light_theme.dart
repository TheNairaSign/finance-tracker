import 'package:finance_tracker/core/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData.light(useMaterial3: true).copyWith(
  scaffoldBackgroundColor: GlobalColors.background,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
  brightness: Brightness.light,
);