import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    // colorScheme: ColorScheme.light(),
    colorScheme: ColorScheme(
      primary: Color(0xFF9575CD),
      primaryVariant: Color(0xFF65499C),
      secondary: Color(0xFFB39DDB),
      secondaryVariant: Color(0xFF836FA9),
      surface: Colors.white,
      background: Colors.white,
      error: Color(0xffb00020),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    // primarySwatch: Colors.pink,

    // unselectedWidgetColor: Colors.deepPurple,
    // switchTheme: SwitchThemeData(
    //   thumbColor: MaterialStateProperty.all(Colors.white),
    // ),
    fontFamily: GoogleFonts.exo2().fontFamily,
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(color: Color(0xFF9575CD)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Color(0xFF9575CD), width: 1.5)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Color(0xFF9575CD), width: 2)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Color(0xFF9575CD), width: 2))),
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    // colorScheme: ColorScheme.dark(),
    colorScheme: ColorScheme(
      primary: Color(0xFF673AB7),
      primaryVariant: Color(0xFF320B86),
      secondary: Color(0xFF5E35B1),
      secondaryVariant: Color(0xFF280680),
      surface: Colors.black,
      background: Colors.black,
      error: Color(0xffcd3e5a),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.black,
      brightness: Brightness.dark,
    ),
    // unselectedWidgetColor: Colors.deepPurple,
    // switchTheme: SwitchThemeData(
    //   thumbColor: MaterialStateProperty.all(Colors.black),
    // )
    fontFamily: GoogleFonts.exo2().fontFamily,
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.black,
        hintStyle: TextStyle(color: Color(0xFF673AB7)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:
                BorderSide(color: Color(0xFF673AB7), width: 1.5)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:
                BorderSide(color: Color(0xFF673AB7), width: 2)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:
                BorderSide(color: Colors.deepPurple.shade700, width: 2))
    ),
    //Jeśli byś chciał kiedyś zmienic kolor ikon lub dodatków
    // iconTheme: IconThemeData(
    //   color: Colors.white
    // ),
  );
}
