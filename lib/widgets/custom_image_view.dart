import 'package:flutter/material.dart';

class CustomImageView {
  static const String orangeSymbolPath = 'assets/images/orange_simbol.png';
  static String whiteLogoPath = 'assets/images/white_logo.png';

  static Image orangeSymbol({double? width, double? height, BoxFit? fit}) {
    return Image.asset(
      'assets/images/orange_simbol.png',
      width: width,
      height: height,
      fit: fit,
    );
  }

  static Image whiteLogo({double? width, double? height, BoxFit? fit}) {
    return Image.asset(
      'assets/images/white_logo.png',
      width: width,
      height: height,
      fit: fit,
    );
  }
}
