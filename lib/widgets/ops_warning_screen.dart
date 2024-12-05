// ignore_for_file: non_constant_identifier_names

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lukatout/constant/colors.dart';
import 'package:lukatout/widgets/secondary_button.dart';

class OpsWarningScreen extends StatelessWidget {
  final message;
  final title;
  final VoidCallback onClosing;
  final VoidCallback goBack;
  final bool can_show_go_back_btn;
  final bool hidde_all_btn;

  const OpsWarningScreen(
      {super.key,
      required this.message,
      required this.onClosing,
      required this.goBack,
      this.can_show_go_back_btn = false,
      this.title = "Attention !",
      required this.hidde_all_btn});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          const SizedBox(
            height: 40.0,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: Column(
              children: [
                FadeInUp(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: SvgPicture.string(
                          '''<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z" />
                          </svg>
                        ''',
                          // ignore: deprecated_member_use
                          color: DigiPublicAColors.orangeColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                FadeInDown(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          "$title",
                          style: const TextStyle(
                              color: DigiPublicAColors.orangeColor,
                              fontWeight: FontWeight.w800),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                FadeInUp(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          "$message",
                          style: const TextStyle(fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (hidde_all_btn == false)
            const SizedBox(
              height: 25.0,
            ),
          if (hidde_all_btn == false)
            FadeInDown(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (can_show_go_back_btn == true)
                    SecondaryButton(
                      activityIsRunning: false,
                      label: "Retour",
                      onPressed: () {
                        goBack();
                      },
                    ),
                  if (can_show_go_back_btn == true)
                    const SizedBox(
                      width: 15.0,
                    ),
                  if (hidde_all_btn == false)
                    DangerButton(
                      activityIsRunning: false,
                      label: "Fermer",
                      onPressed: () {
                        onClosing();
                      },
                    ),
                ],
              ),
            ),
          if (hidde_all_btn == false)
            const SizedBox(
              height: 30.0,
            ),
        ],
      ),
    );
  }
}
