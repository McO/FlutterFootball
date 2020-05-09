import 'package:flutter/material.dart';

import 'colors.dart';

ThemeData buildThemeData() {
  final baseTheme = ThemeData(
    fontFamily: "FiraCode",
  );

  return baseTheme.copyWith(
    primaryColor: kPrimaryColor,
    primaryColorDark: kPrimaryDark,
    primaryColorLight: kPrimaryLight,
    accentColor: kSecondaryColor,
    bottomAppBarColor: kSecondaryDark,
    buttonColor: kSecondaryColor,
    sliderTheme: SliderThemeData.fromPrimaryColors(
      primaryColor: kPrimaryColor,
      primaryColorDark: kPrimaryDark,
      primaryColorLight: kPrimaryLight,
      valueIndicatorTextStyle: TextStyle(),
    ),

    textTheme: TextTheme(
      headline5: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
      headline6: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
      subtitle2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.black),
      bodyText2: TextStyle(fontSize: 16.0, color: Colors.black),
      subtitle1: TextStyle(fontSize: 16.0, color: Colors.black),
      headline4: TextStyle(fontSize: 16.0, color: Colors.white),
      headline3: TextStyle(fontSize: 14.0, color: Colors.white),
    ),
  );
}
