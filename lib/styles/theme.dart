import 'package:flutter/material.dart';
import '/styles/color.dart';

ThemeData lightTheme({required color}) {
  return ThemeData(
    primarySwatch: color,
    canvasColor: whiteColor2,
    fontFamily: 'Anek-SemiBold', //
    scaffoldBackgroundColor: whiteColor1,
    appBarTheme: const AppBarTheme(
      titleSpacing: 20.0,
      backgroundColor: whiteColor1,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: whiteColor1,
      elevation: 30.0,
      selectedItemColor: color,
      unselectedItemColor: Colors.black54,
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(Colors.black),
    ),
    textTheme: TextTheme(
      headline1: const TextStyle(
        color: Colors.black,
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      ),
      subtitle1: TextStyle(
        color: Colors.grey[700],
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    ),
  );
}

ThemeData darkTheme({required color}) {
  return ThemeData(
    primarySwatch: color,
    canvasColor: blackColor1,
    fontFamily: 'Anek-SemiBold', //
    scaffoldBackgroundColor: blackColor2,
    appBarTheme: const AppBarTheme(
      titleSpacing: 20.0,
      backgroundColor: blackColor2,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: blackColor2,
      elevation: 30.0,
      selectedItemColor: color,
      unselectedItemColor: Colors.grey[300],
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(Colors.white),
    ),
    textTheme: TextTheme(
      headline1: const TextStyle(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      ),
      subtitle1: TextStyle(
        color: Colors.grey[500],
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    ),
  );
}
