import 'package:flutter/material.dart';
import 'package:lukatout/constant/colors.dart';

class DigiProgressIndicator extends StatelessWidget {
  const DigiProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 90.0,
      width: 90.0,
      child: Stack(
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/icon/app-icon.png'),
            ),
          ),
          Center(
            child: SizedBox(
              height: 80.0,
              width: 80.0,
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
                color: DigiPublicAColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
