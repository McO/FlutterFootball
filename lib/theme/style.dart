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
      headline5: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: kTextColor),
      headline6: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: kTextColor),
      subtitle2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: kTextColor),
      bodyText2: TextStyle(fontSize: 16.0, color: kTextColor),
      subtitle1: TextStyle(fontSize: 16.0, color: kTextColor),
      headline4: TextStyle(fontSize: 16.0, color: kTextColorLight),
      headline3: TextStyle(fontSize: 14.0, color: kTextColorLight),
      caption: TextStyle(
        fontSize: 12.0,
        color: kTextColor,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
