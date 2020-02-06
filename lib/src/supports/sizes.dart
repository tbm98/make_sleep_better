import 'package:flutter/material.dart';

class Sizes{
  static double getHeightNoAppbar(BuildContext context) {
    return MediaQuery.of(context).size.height -
        Scaffold.of(context).appBarMaxHeight;
  }

  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}