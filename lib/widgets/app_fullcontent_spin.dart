import 'package:digipublic_studiant/constant/colors.dart';
import 'package:digipublic_studiant/widgets/digi_progress_indicator.dart';
import 'package:flutter/material.dart';

class AppFullcontentSpin extends StatelessWidget {
  final Widget child;
  final bool activityIsRunning;
  final String message;
  const AppFullcontentSpin(
      {super.key,
      this.message = 'en cours...',
      required this.child,
      this.activityIsRunning = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (activityIsRunning == true)
          Column(
            children: [
              Expanded(
                  child: Container(
                color: DigiPublicAColors.primaryColor.withOpacity(.5),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const DigiProgressIndicator(),
                    // const CircularProgressIndicator(
                    //   strokeWidth: 2.0,
                    //   backgroundColor: Colors.white,
                    // ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      message,
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                ),
              )),
            ],
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}
