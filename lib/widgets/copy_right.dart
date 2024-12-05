import 'package:flutter/material.dart';
import 'package:lukatout/constant/colors.dart';

class CopyRightWidget extends StatelessWidget {
  const CopyRightWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Icon(Icons.copyright,
            size: 14, color: DigiPublicAColors.whiteColor),
        const SizedBox(
          width: 5.0,
        ),
        Container(
          width: 15.0,
          height: 15.0,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/icon/sycamore-white.png"),
                  fit: BoxFit.contain)),
        ),
        const SizedBox(
          width: 5.0,
        ),
        RichText(
          text: const TextSpan(
              text: "Sycamore",
              style: TextStyle(
                  color: DigiPublicAColors.whiteColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 15),
              children: <InlineSpan>[
                TextSpan(
                    text: " Sarl",
                    style: TextStyle(
                        color: DigiPublicAColors.whiteColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 15)),
              ]),
        ),
      ],
    );
  }
}
