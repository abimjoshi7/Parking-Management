import 'package:flutter/material.dart';

//colors
const kColorPrimary = Color(0xFF411360);
const kColorWhite = Colors.white;
const kColorSecondary = Color(0xFFE50607);
const kColorGreen = Color(0xff33F133);

//textstyle
const kHeadTitle = TextStyle(color: kColorPrimary, fontSize: 20);

//themedata
class CustomTheme {
  static kThemeData1() {
    return ThemeData(
      appBarTheme: const AppBarTheme(backgroundColor: kColorPrimary),
      primaryColor: kColorPrimary,
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          fixedSize: const Size.fromWidth(200),
          side: const BorderSide(color: Colors.blueGrey),
        ),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
            fontSize: 25, fontWeight: FontWeight.w400, color: Colors.black),
        labelLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Colors.amber,
        ),
      ),
    );
  }

  static kThemeData() => ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: kColorPrimary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: kColorPrimary, minimumSize: const Size(100, 30)),
        ),
        checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.all(kColorPrimary)),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateColor.resolveWith((states) => kColorPrimary),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: kColorPrimary),
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(backgroundColor: kColorPrimary),
        inputDecorationTheme: const InputDecorationTheme(
          prefixIconColor: kColorPrimary,
          suffixIconColor: kColorPrimary,
          labelStyle: TextStyle(color: kColorPrimary),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kColorPrimary),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(backgroundColor: kColorPrimary),
        dialogTheme: const DialogTheme(
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 22),
          contentTextStyle: TextStyle(fontSize: 18, color: Colors.black),
        ),
      );
}
