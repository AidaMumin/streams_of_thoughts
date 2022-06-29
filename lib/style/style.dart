//Aida Mumin
//CSC 4360 - Umoja
//June 28, 2022
//Streams of Thoughts

import "package:flutter/material.dart";

//Colors
const Color mainColor = Color.fromARGB(255, 255, 103, 184);
const Color mainDarkColor = Colors.red;
const Color mainLightColor = Color.fromARGB(255, 255, 182, 221);

//Text
const double normalText = 18.0;
const double largeText = 18.0;
const double midText = 18.0;

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

void snackBar(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

InputDecoration inputDecorating(String tag, [hint]) => InputDecoration(
  labelText: tag,
  hintText: hint
);
