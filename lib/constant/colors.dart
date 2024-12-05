// Flutter imports:
import 'package:flutter/material.dart';

class DigiPublicAColors {
  static const primaryColor = Color(0xFF048996);
  static const greenColor = Color.fromARGB(255, 2, 125, 8);

  static const secondaryColor = Color(0xFF263146);
  static const orangeColor = Color(0xFFF6A831);
  static const redColor = Color(0xFFFF0000);
  static const whiteColor = Color(0xFFFFFFFF);
  static const blackColor = Color(0xFF000000);
  static const greyColor = Color.fromARGB(255, 148, 149, 148);
  static const darkGreyColor = Color.fromRGBO(66, 66, 66, 1);

  ///Singleton factory
  static final DigiPublicAColors _instance = DigiPublicAColors._internal();
  factory DigiPublicAColors() => _instance;
  DigiPublicAColors._internal();
}
