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
//    textTheme: TextTheme().copyWith(
//        subhead: TextStyle(
//          //fontFamily: "SnackerComic",
//        )),
  );
}
