import 'package:flutter/material.dart';

class HorizontalSpace {
  static const Widget tiny = SizedBox(width: 5.0);
  static const Widget small = SizedBox(width: 10.0);
  static const Widget regular = SizedBox(width: 18.0);
  static const Widget medium = SizedBox(width: 25.0);
  static const Widget large = SizedBox(width: 50.0);
}

class VerticalSpace {
  static const Widget tiny = SizedBox(height: 5.0);
  static const Widget small = SizedBox(height: 10.0);
  static const Widget regular = SizedBox(height: 18.0);
  static const Widget medium = SizedBox(height: 25.0);
  static const Widget large = SizedBox(height: 50.0);
}

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double screenWidthPercentage(BuildContext context, {double percentage = 1}) =>
    screenWidth(context) * percentage;
double screenHeightPercentage(BuildContext context, {double percentage = 1}) =>
    screenHeight(context) * percentage;
