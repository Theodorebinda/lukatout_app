import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<Widget> loadLocalSvgFile(String svgName) async {
  try {
    String assetPath = 'assets/svg/$svgName';
    // await rootBundle.loadString(assetPath);
    // return SvgPicture.asset('assets/svg/$svgName');
    return SvgPicture.asset('assets/svg/default.svg');
  } catch (e) {
    return SvgPicture.asset('assets/svg/default.svg');
  }
}

// UPPERCASE FIRST LETTER
extension CapitalizeFirstLetterExtensions on String {
  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}

extension CapitalizeExtensions on String {
  String capitalizeEachWord() {
    return split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
