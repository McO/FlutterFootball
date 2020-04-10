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
      headline: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
      title: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
      subtitle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.black),
      body1: TextStyle(fontSize: 16.0, color: Colors.black),
      subhead: TextStyle(fontSize: 16.0, color: Colors.black),
      display1: TextStyle(fontSize: 16.0, color: Colors.white),
    ),
  );
}
