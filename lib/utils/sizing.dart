import 'package:flutter/material.dart';

class AppSizing {
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;
  static double kHPercentage(BuildContext context, double value) =>
      (height(context) * value) / 100;
  static double kWPercentage(BuildContext context, double value) =>
      (width(context) * value) / 100;

  static Widget kh20Spacer() => SizedBox(height: 20);
  static Widget kh10Spacer() => SizedBox(height: 10);

  static Widget khSpacer(double height) => SizedBox(height: height);

  static Widget kwSpacer(double width) => SizedBox(width: width);

  static EdgeInsets kMainPadding(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: 30);
}
